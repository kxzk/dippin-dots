#!/usr/bin/env python3

from __future__ import annotations

import argparse
import datetime as dt
import json
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Sequence
from urllib.parse import quote

NOREPLY_PATTERN: re.Pattern[str] = re.compile(
    r"^(?:\d+\+)?([A-Za-z0-9\-\[\]]+)@users\.noreply\.github\.com$"
)
GITHUB_REMOTE_PATTERNS: tuple[re.Pattern[str], ...] = (
    re.compile(
        r"^git@github\.com:(?P<owner>[^/]+)/(?P<repo>[^/]+?)(?:\.git)?$",
        re.IGNORECASE,
    ),
    re.compile(
        r"^(?:https?://|ssh://git@)github\.com/(?P<owner>[^/]+)/(?P<repo>[^/]+?)(?:\.git)?/?$",
        re.IGNORECASE,
    ),
)


class CommandError(RuntimeError):
    pass


@dataclass(frozen=True)
class CommitRecord:
    author_name: str
    author_email: str
    authored_at: dt.datetime


@dataclass
class Candidate:
    key: str
    login: str | None
    name: str
    emails: set[str] = field(default_factory=set)
    touched_files: set[str] = field(default_factory=set)
    touch_commits: int = 0
    base_score: float = 0.0
    score: float = 0.0
    last_touched_at: dt.datetime | None = None
    last_repo_activity_at: dt.datetime | None = None
    repo_access: bool | None = None


def run_command(
    command: Sequence[str],
    cwd: Path | None = None,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    completed: subprocess.CompletedProcess[str] = subprocess.run(
        list(command),
        cwd=str(cwd) if cwd else None,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if check and completed.returncode != 0:
        joined: str = " ".join(command)
        message: str = completed.stderr.strip() or completed.stdout.strip()
        raise CommandError(f"Command failed ({joined}): {message}")
    return completed


def run_git(
    args: Sequence[str],
    repo_root: Path,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    return run_command(["git", *args], cwd=repo_root, check=check)


def resolve_repo_root(start: Path) -> Path:
    completed: subprocess.CompletedProcess[str] = run_command(
        ["git", "rev-parse", "--show-toplevel"],
        cwd=start,
        check=True,
    )
    return Path(completed.stdout.strip()).resolve()


def ref_exists(repo_root: Path, ref: str) -> bool:
    completed: subprocess.CompletedProcess[str] = run_git(
        ["rev-parse", "--verify", "--quiet", f"{ref}^{{commit}}"],
        repo_root,
        check=False,
    )
    return completed.returncode == 0


def detect_base_ref(repo_root: Path) -> str:
    origin_head: subprocess.CompletedProcess[str] = run_git(
        ["symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD"],
        repo_root,
        check=False,
    )
    if origin_head.returncode == 0 and origin_head.stdout.strip():
        return origin_head.stdout.strip()

    for candidate in ("origin/main", "origin/master", "main", "master"):
        if ref_exists(repo_root, candidate):
            return candidate

    raise CommandError("Unable to auto-detect base ref. Pass --base explicitly.")


def parse_timestamp(value: str) -> dt.datetime:
    parsed: dt.datetime = dt.datetime.fromisoformat(value)
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=dt.timezone.utc)
    return parsed.astimezone(dt.timezone.utc)


def parse_commit_records(raw_output: str) -> list[CommitRecord]:
    records: list[CommitRecord] = []
    for line in raw_output.splitlines():
        if not line.strip():
            continue
        parts: list[str] = line.split("\t", 2)
        if len(parts) != 3:
            continue
        author_name, author_email, authored_raw = parts
        records.append(
            CommitRecord(
                author_name=author_name.strip(),
                author_email=author_email.strip().lower(),
                authored_at=parse_timestamp(authored_raw.strip()),
            )
        )
    return records


def infer_login(email: str) -> str | None:
    matched: re.Match[str] | None = NOREPLY_PATTERN.match(email.lower())
    if not matched:
        return None
    return matched.group(1).lower()


def is_bot(author_name: str, author_email: str, login: str | None) -> bool:
    candidate_values: list[str] = [author_name.lower(), author_email.lower()]
    if login:
        candidate_values.append(login.lower())
    return any("[bot]" in value for value in candidate_values)


def candidate_keys(candidate: Candidate) -> set[str]:
    keys: set[str] = {candidate.key}
    keys.update(candidate.emails)
    if candidate.login:
        keys.add(candidate.login.lower())
        keys.add(candidate.login.lower().lstrip("@"))
    return keys


def parse_excludes(raw_excludes: Sequence[str]) -> set[str]:
    excludes: set[str] = set()
    for raw in raw_excludes:
        for part in raw.split(","):
            token: str = part.strip()
            if not token:
                continue
            lowered: str = token.lower()
            excludes.add(lowered)
            excludes.add(lowered.lstrip("@"))
    return excludes


def recency_weight(now: dt.datetime, authored_at: dt.datetime) -> float:
    days_old: float = max((now - authored_at).total_seconds() / 86400.0, 0.0)
    return 1.0 / (1.0 + (days_old / 45.0))


def list_changed_files(repo_root: Path, merge_base: str, head_ref: str) -> list[str]:
    completed: subprocess.CompletedProcess[str] = run_git(
        ["diff", "--name-only", "--diff-filter=ACMR", merge_base, head_ref],
        repo_root,
        check=True,
    )
    return [line.strip() for line in completed.stdout.splitlines() if line.strip()]


def read_file_history(
    repo_root: Path,
    base_ref: str,
    file_path: str,
    max_commits: int,
) -> list[CommitRecord]:
    completed: subprocess.CompletedProcess[str] = run_git(
        [
            "log",
            "--no-merges",
            f"--max-count={max_commits}",
            "--format=%aN%x09%aE%x09%aI",
            base_ref,
            "--",
            file_path,
        ],
        repo_root,
        check=True,
    )
    return parse_commit_records(completed.stdout)


def collect_branch_author_keys(repo_root: Path, merge_base: str, head_ref: str) -> set[str]:
    completed: subprocess.CompletedProcess[str] = run_git(
        [
            "log",
            "--no-merges",
            "--format=%aN%x09%aE%x09%aI",
            f"{merge_base}..{head_ref}",
        ],
        repo_root,
        check=True,
    )
    keys: set[str] = set()
    for record in parse_commit_records(completed.stdout):
        keys.add(record.author_email.lower())
        login: str | None = infer_login(record.author_email)
        if login:
            keys.add(login.lower())
    return keys


def collect_current_user_keys(repo_root: Path) -> set[str]:
    keys: set[str] = set()
    completed: subprocess.CompletedProcess[str] = run_git(
        ["config", "--get", "user.email"],
        repo_root,
        check=False,
    )
    if completed.returncode == 0 and completed.stdout.strip():
        email: str = completed.stdout.strip().lower()
        keys.add(email)
        login: str | None = infer_login(email)
        if login:
            keys.add(login.lower())
    return keys


def collect_recent_activity(
    repo_root: Path,
    base_ref: str,
    activity_days: int,
) -> dict[str, dt.datetime]:
    since_date: str = (dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=activity_days)).date().isoformat()
    completed: subprocess.CompletedProcess[str] = run_git(
        [
            "log",
            "--no-merges",
            f"--since={since_date}",
            "--format=%aN%x09%aE%x09%aI",
            base_ref,
        ],
        repo_root,
        check=True,
    )

    last_activity: dict[str, dt.datetime] = {}
    for record in parse_commit_records(completed.stdout):
        for key in (record.author_email.lower(), infer_login(record.author_email)):
            if not key:
                continue
            previous: dt.datetime | None = last_activity.get(key)
            if previous is None or record.authored_at > previous:
                last_activity[key] = record.authored_at
    return last_activity


def parse_github_remote(repo_root: Path) -> tuple[str, str] | None:
    completed: subprocess.CompletedProcess[str] = run_git(
        ["config", "--get", "remote.origin.url"],
        repo_root,
        check=False,
    )
    if completed.returncode != 0:
        return None
    remote_url: str = completed.stdout.strip()
    if not remote_url:
        return None

    for pattern in GITHUB_REMOTE_PATTERNS:
        matched: re.Match[str] | None = pattern.match(remote_url)
        if matched:
            owner: str = matched.group("owner")
            repo: str = matched.group("repo")
            return owner, repo
    return None


def gh_available() -> bool:
    try:
        completed: subprocess.CompletedProcess[str] = run_command(
            ["gh", "--version"],
            check=False,
        )
    except FileNotFoundError:
        return False
    return completed.returncode == 0


def check_collaborator_access(owner: str, repo: str, login: str) -> bool | None:
    endpoint: str = f"repos/{owner}/{repo}/collaborators/{quote(login, safe='')}"
    completed: subprocess.CompletedProcess[str] = run_command(
        ["gh", "api", endpoint],
        check=False,
    )
    if completed.returncode == 0:
        return True

    combined: str = f"{completed.stdout}\n{completed.stderr}".lower()
    if "404" in combined or "not found" in combined:
        return False
    if "forbidden" in combined or "403" in combined or "resource not accessible" in combined:
        return None
    return None


def render_text(result: dict[str, object]) -> str:
    suggestions: list[dict[str, object]] = result["suggestions"]  # type: ignore[assignment]
    lines: list[str] = [
        f"Base: {result['base_ref']}",
        f"Head: {result['head_ref']}",
        f"Changed files: {result['changed_file_count']}",
        f"Activity window: {result['activity_days']} days",
        "",
    ]

    if not suggestions:
        lines.append("No active reviewer suggestions found.")
    else:
        lines.append("Top reviewer suggestions:")
        for index, suggestion in enumerate(suggestions, start=1):
            reviewer: str = suggestion["reviewer"]  # type: ignore[assignment]
            score: float = suggestion["score"]  # type: ignore[assignment]
            files_covered: int = suggestion["files_covered"]  # type: ignore[assignment]
            commits: int = suggestion["commits_on_changed_files"]  # type: ignore[assignment]
            last_touch: str = suggestion["last_touched_at"]  # type: ignore[assignment]
            last_active: str | None = suggestion["last_repo_activity_at"]  # type: ignore[assignment]
            lines.append(
                f"{index}. {reviewer} | score={score:.3f} | files={files_covered} | "
                f"commits={commits} | last_touch={last_touch} | last_active={last_active or 'unknown'}"
            )

    skipped: dict[str, int] = result["skipped"]  # type: ignore[assignment]
    lines.extend(
        [
            "",
            "Skipped candidates:",
            f"- inactive: {skipped['inactive']}",
            f"- no_login: {skipped['no_login']}",
            f"- not_collaborator: {skipped['not_collaborator']}",
            "",
        ]
    )

    notes: list[str] = result["notes"]  # type: ignore[assignment]
    if notes:
        lines.append("Notes:")
        for note in notes:
            lines.append(f"- {note}")
    return "\n".join(lines).strip()


def build_argument_parser() -> argparse.ArgumentParser:
    parser: argparse.ArgumentParser = argparse.ArgumentParser(
        description="Suggest top PR reviewers based on git history for changed files.",
    )
    parser.add_argument("--base", help="Base branch/ref. Defaults to origin/HEAD.")
    parser.add_argument("--head", default="HEAD", help="Head ref to compare (default: HEAD).")
    parser.add_argument("--top", type=int, default=3, help="Number of reviewer suggestions.")
    parser.add_argument(
        "--activity-days",
        type=int,
        default=180,
        help="Require reviewer activity in this repo within the last N days.",
    )
    parser.add_argument(
        "--history-per-file",
        type=int,
        default=200,
        help="Max commits to scan per changed file when scoring ownership.",
    )
    parser.add_argument(
        "--exclude",
        action="append",
        default=[],
        help="Reviewer handles/emails to exclude (repeat or comma-separate).",
    )
    parser.add_argument(
        "--allow-non-login",
        action="store_true",
        help="Allow suggestions without GitHub login mapping.",
    )
    parser.add_argument(
        "--no-gh-access-check",
        action="store_true",
        help="Skip GitHub collaborator access checks even when gh is available.",
    )
    parser.add_argument("--json", action="store_true", help="Emit JSON output.")
    return parser


def main() -> int:
    parser: argparse.ArgumentParser = build_argument_parser()
    args: argparse.Namespace = parser.parse_args()

    if args.top < 1:
        parser.error("--top must be >= 1")
    if args.activity_days < 1:
        parser.error("--activity-days must be >= 1")
    if args.history_per_file < 1:
        parser.error("--history-per-file must be >= 1")

    repo_root: Path = resolve_repo_root(Path.cwd())
    base_ref: str = args.base or detect_base_ref(repo_root)
    head_ref: str = args.head

    if not ref_exists(repo_root, base_ref):
        raise CommandError(f"Base ref not found: {base_ref}")
    if not ref_exists(repo_root, head_ref):
        raise CommandError(f"Head ref not found: {head_ref}")

    merge_base_completed: subprocess.CompletedProcess[str] = run_git(
        ["merge-base", base_ref, head_ref],
        repo_root,
        check=True,
    )
    merge_base: str = merge_base_completed.stdout.strip()
    changed_files: list[str] = list_changed_files(repo_root, merge_base, head_ref)

    notes: list[str] = []
    if not changed_files:
        result: dict[str, object] = {
            "repo_root": str(repo_root),
            "base_ref": base_ref,
            "head_ref": head_ref,
            "merge_base": merge_base,
            "changed_file_count": 0,
            "activity_days": args.activity_days,
            "suggestions": [],
            "skipped": {"inactive": 0, "no_login": 0, "not_collaborator": 0},
            "notes": ["No changed files between base and head."],
        }
        if args.json:
            print(json.dumps(result, indent=2))
        else:
            print(render_text(result))
        return 0

    now: dt.datetime = dt.datetime.now(dt.timezone.utc)
    candidates: dict[str, Candidate] = {}
    for file_path in changed_files:
        for record in read_file_history(repo_root, base_ref, file_path, args.history_per_file):
            login: str | None = infer_login(record.author_email)
            if is_bot(record.author_name, record.author_email, login):
                continue
            key: str = login or record.author_email.lower()
            candidate: Candidate | None = candidates.get(key)
            if candidate is None:
                candidate = Candidate(key=key, login=login, name=record.author_name)
                candidates[key] = candidate
            candidate.emails.add(record.author_email.lower())
            candidate.touched_files.add(file_path)
            candidate.touch_commits += 1
            candidate.base_score += recency_weight(now, record.authored_at)
            if candidate.last_touched_at is None or record.authored_at > candidate.last_touched_at:
                candidate.last_touched_at = record.authored_at

    excluded_keys: set[str] = parse_excludes(args.exclude)
    excluded_keys.update(collect_branch_author_keys(repo_root, merge_base, head_ref))
    excluded_keys.update(collect_current_user_keys(repo_root))

    filtered_candidates: list[Candidate] = []
    for candidate in candidates.values():
        if candidate_keys(candidate) & excluded_keys:
            continue
        coverage_ratio: float = len(candidate.touched_files) / max(len(changed_files), 1)
        candidate.score = candidate.base_score * (1.0 + coverage_ratio)
        filtered_candidates.append(candidate)
    if not filtered_candidates:
        notes.append("No reviewer candidates remained after filtering bots and branch authors.")

    recent_activity: dict[str, dt.datetime] = collect_recent_activity(
        repo_root,
        base_ref,
        args.activity_days,
    )
    for candidate in filtered_candidates:
        latest: dt.datetime | None = None
        for key in candidate_keys(candidate):
            activity: dt.datetime | None = recent_activity.get(key)
            if activity and (latest is None or activity > latest):
                latest = activity
        candidate.last_repo_activity_at = latest

    filtered_candidates.sort(
        key=lambda candidate: (
            -candidate.score,
            -len(candidate.touched_files),
            -candidate.touch_commits,
            -candidate.last_touched_at.timestamp() if candidate.last_touched_at else 0.0,
        )
    )

    github_remote: tuple[str, str] | None = parse_github_remote(repo_root)
    use_gh_check: bool = bool(github_remote) and gh_available() and not args.no_gh_access_check
    if github_remote and not use_gh_check and not args.no_gh_access_check:
        notes.append("GitHub remote detected but collaborator checks were skipped (gh unavailable).")
    if args.no_gh_access_check:
        notes.append("GitHub collaborator checks explicitly disabled.")

    owner: str | None = None
    repo: str | None = None
    if github_remote:
        owner, repo = github_remote

    skipped_inactive: int = 0
    skipped_no_login: int = 0
    skipped_not_collaborator: int = 0
    selected: list[Candidate] = []

    for candidate in filtered_candidates:
        if candidate.last_repo_activity_at is None:
            skipped_inactive += 1
            continue
        if not candidate.login and not args.allow_non_login:
            skipped_no_login += 1
            continue
        if use_gh_check and owner and repo and candidate.login:
            access: bool | None = check_collaborator_access(owner, repo, candidate.login)
            candidate.repo_access = access
            if access is False:
                skipped_not_collaborator += 1
                continue
        selected.append(candidate)
        if len(selected) >= args.top:
            break
    if not selected and filtered_candidates:
        notes.append(
            "No reviewer suggestions passed the active/login/access filters; widen activity window or exclusions."
        )

    suggestions: list[dict[str, object]] = []
    for candidate in selected:
        reviewer: str = f"@{candidate.login}" if candidate.login else candidate.name
        suggestions.append(
            {
                "reviewer": reviewer,
                "login": candidate.login,
                "name": candidate.name,
                "score": round(candidate.score, 6),
                "files_covered": len(candidate.touched_files),
                "commits_on_changed_files": candidate.touch_commits,
                "last_touched_at": candidate.last_touched_at.isoformat() if candidate.last_touched_at else None,
                "last_repo_activity_at": (
                    candidate.last_repo_activity_at.isoformat()
                    if candidate.last_repo_activity_at
                    else None
                ),
                "repo_access_check": (
                    "confirmed"
                    if candidate.repo_access is True
                    else "unverified"
                    if candidate.repo_access is None
                    else "not-collaborator"
                ),
            }
        )

    result = {
        "repo_root": str(repo_root),
        "base_ref": base_ref,
        "head_ref": head_ref,
        "merge_base": merge_base,
        "changed_file_count": len(changed_files),
        "activity_days": args.activity_days,
        "used_gh_collaborator_check": use_gh_check,
        "suggestions": suggestions,
        "skipped": {
            "inactive": skipped_inactive,
            "no_login": skipped_no_login,
            "not_collaborator": skipped_not_collaborator,
        },
        "notes": notes,
    }

    if args.json:
        print(json.dumps(result, indent=2))
    else:
        print(render_text(result))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except CommandError as error:
        print(str(error), file=sys.stderr)
        raise SystemExit(1)
