#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from typing import Any

LINEAR_GRAPHQL_URL = "https://api.linear.app/graphql"
PAGE_SIZE = 250


@dataclass(frozen=True)
class ReservationIssue:
    identifier: str
    state_type: str
    label_names: tuple[str, ...]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Find first unreserved staging namespace from Linear .reserved labels."
    )
    parser.add_argument("--prefix", default="rev", help="Namespace prefix, e.g. rev or qa.")
    parser.add_argument("--start", type=int, default=1, help="Inclusive numeric start.")
    parser.add_argument("--end", type=int, default=99, help="Inclusive numeric end.")
    parser.add_argument("--width", type=int, default=2, help="Zero-pad width for namespace numbers.")
    parser.add_argument(
        "--reserved-suffix",
        default=".reserved",
        help="Reservation label suffix.",
    )
    parser.add_argument(
        "--linear-token",
        default=os.environ.get("LINEAR_API_KEY", ""),
        help="Linear API token. Defaults to LINEAR_API_KEY.",
    )
    parser.add_argument(
        "--inactive-state",
        action="append",
        default=["completed", "canceled"],
        help="Issue state type treated as inactive. Repeat to add more.",
    )
    parser.add_argument(
        "--format",
        choices=("human", "json", "raw"),
        default="human",
        help="Output format.",
    )
    return parser.parse_args()


def post_linear_graphql(token: str, query: str, variables: dict[str, Any]) -> dict[str, Any]:
    payload = json.dumps({"query": query, "variables": variables}).encode("utf-8")
    request = urllib.request.Request(
        LINEAR_GRAPHQL_URL,
        data=payload,
        headers={
            "Authorization": token,
            "Content-Type": "application/json",
        },
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        raw = response.read().decode("utf-8")
    decoded = json.loads(raw)
    if decoded.get("errors"):
        raise RuntimeError(json.dumps(decoded["errors"]))
    data = decoded.get("data")
    if not isinstance(data, dict):
        raise RuntimeError(f"Unexpected Linear response payload: {raw}")
    return data


def issues_query(operator: str) -> str:
    return f"""
query ReservedIssues($after: String, $first: Int!, $needle: String!) {{
  issues(
    first: $first
    after: $after
    filter: {{ labels: {{ name: {{ {operator}: $needle }} }} }}
  ) {{
    pageInfo {{
      hasNextPage
      endCursor
    }}
    nodes {{
      identifier
      state {{
        type
      }}
      labels {{
        nodes {{
          name
        }}
      }}
    }}
  }}
}}
""".strip()


def parse_labels(raw_labels: Any) -> tuple[str, ...]:
    if isinstance(raw_labels, dict):
        nodes = raw_labels.get("nodes")
        if isinstance(nodes, list):
            names = [
                node.get("name")
                for node in nodes
                if isinstance(node, dict) and isinstance(node.get("name"), str)
            ]
            return tuple(names)
    if isinstance(raw_labels, list):
        names = [item.get("name") for item in raw_labels if isinstance(item, dict) and isinstance(item.get("name"), str)]
        return tuple(names)
    return tuple()


def fetch_reservation_issues(token: str, needle: str) -> list[ReservationIssue]:
    last_error = ""
    for operator in ("containsIgnoreCase", "contains"):
        try:
            return fetch_reservation_issues_for_operator(token, operator, needle)
        except Exception as err:  # noqa: BLE001
            last_error = str(err)
    raise RuntimeError(f"Linear query failed for all supported filters: {last_error}")


def fetch_reservation_issues_for_operator(token: str, operator: str, needle: str) -> list[ReservationIssue]:
    issues: list[ReservationIssue] = []
    after: str | None = None
    while True:
        data = post_linear_graphql(
            token=token,
            query=issues_query(operator),
            variables={
                "after": after,
                "first": PAGE_SIZE,
                "needle": needle,
            },
        )
        issues_block = data.get("issues", {})
        nodes = issues_block.get("nodes", [])
        page_info = issues_block.get("pageInfo", {})

        if not isinstance(nodes, list):
            raise RuntimeError("Linear response missing issues.nodes")
        if not isinstance(page_info, dict):
            raise RuntimeError("Linear response missing issues.pageInfo")

        for node in nodes:
            if not isinstance(node, dict):
                continue
            identifier = node.get("identifier", "")
            state_type = (
                ((node.get("state") or {}).get("type") if isinstance(node.get("state"), dict) else "") or ""
            )
            labels = parse_labels(node.get("labels"))
            issues.append(
                ReservationIssue(
                    identifier=str(identifier),
                    state_type=str(state_type).lower(),
                    label_names=labels,
                )
            )

        has_next_page = bool(page_info.get("hasNextPage"))
        if not has_next_page:
            break
        end_cursor = page_info.get("endCursor")
        if not isinstance(end_cursor, str) or not end_cursor:
            break
        after = end_cursor

    return issues


def collect_reserved_namespaces(
    issues: list[ReservationIssue],
    prefix: str,
    suffix: str,
    width: int,
    inactive_states: set[str],
) -> set[str]:
    pattern = re.compile(rf"^{re.escape(prefix)}(\d+){re.escape(suffix)}$")
    reserved: set[str] = set()
    for issue in issues:
        if issue.state_type in inactive_states:
            continue
        for label_name in issue.label_names:
            match = pattern.match(label_name)
            if not match:
                continue
            number = int(match.group(1))
            reserved.add(f"{prefix}{number:0{width}d}")
    return reserved


def pick_free_namespace(prefix: str, start: int, end: int, width: int, reserved: set[str]) -> str | None:
    for number in range(start, end + 1):
        candidate = f"{prefix}{number:0{width}d}"
        if candidate not in reserved:
            return candidate
    return None


def print_result(
    output_format: str,
    selected_namespace: str | None,
    prefix: str,
    start: int,
    end: int,
    width: int,
    reserved: set[str],
) -> None:
    ordered_reserved = sorted(reserved)
    if output_format == "raw":
        if selected_namespace:
            print(selected_namespace)
        return

    if output_format == "json":
        print(
            json.dumps(
                {
                    "selected_namespace": selected_namespace,
                    "range": {"prefix": prefix, "start": start, "end": end},
                    "reserved_count": len(ordered_reserved),
                    "reserved_namespaces": ordered_reserved,
                },
                indent=2,
            )
        )
        return

    if selected_namespace:
        print(f"FREE_NAMESPACE={selected_namespace}")
    else:
        print("FREE_NAMESPACE=")
    print(f"SCANNED_RANGE={prefix}{start:0{width}d}..{prefix}{end:0{width}d}")
    print(f"RESERVED_COUNT={len(ordered_reserved)}")
    if ordered_reserved:
        print(f"RESERVED_NAMESPACES={','.join(ordered_reserved)}")


def main() -> int:
    args = parse_args()
    if not args.linear_token:
        print("LINEAR_API_KEY is required (or pass --linear-token).", file=sys.stderr)
        return 2
    if args.start <= 0 or args.end < args.start:
        print("--start/--end range is invalid.", file=sys.stderr)
        return 2
    if args.width <= 0:
        print("--width must be > 0.", file=sys.stderr)
        return 2

    inactive_states = {state.lower() for state in args.inactive_state}
    try:
        issues = fetch_reservation_issues(args.linear_token, args.reserved_suffix)
        reserved = collect_reserved_namespaces(
            issues=issues,
            prefix=args.prefix,
            suffix=args.reserved_suffix,
            width=args.width,
            inactive_states=inactive_states,
        )
        free_namespace = pick_free_namespace(
            prefix=args.prefix,
            start=args.start,
            end=args.end,
            width=args.width,
            reserved=reserved,
        )
    except urllib.error.HTTPError as err:
        print(f"Linear API HTTP error: {err.code} {err.reason}", file=sys.stderr)
        return 1
    except urllib.error.URLError as err:
        print(f"Linear API connection error: {err.reason}", file=sys.stderr)
        return 1
    except Exception as err:  # noqa: BLE001
        print(f"Linear reservation lookup failed: {err}", file=sys.stderr)
        return 1

    print_result(
        output_format=args.format,
        selected_namespace=free_namespace,
        prefix=args.prefix,
        start=args.start,
        end=args.end,
        width=args.width,
        reserved=reserved,
    )
    return 0 if free_namespace else 3


if __name__ == "__main__":
    raise SystemExit(main())
