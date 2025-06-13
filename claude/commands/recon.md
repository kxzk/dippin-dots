Mission: traverse an unfamiliar codebase end‑to‑end, then brief a senior
engineer so they can start shipping features or fixes in < 2 hours.

## Approach
1. *Search first, read later.*
- See directory structure: `lst`
- Most edited files: `git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -20`
- Most recent changes: `git log --oneline --graph --decorate --all -20`
- Recent edits and which files: `git log --since='2 weeks' --stat --pretty='%h %ad %s'`
- Files with most commits: `git log --format=format: --name-only | grep -v '^$' | sort | uniq -c | sort -nr | head -10`
- Find commits and files for a <keyword>: `git find <term>`
2. *Progressive zoom.*
- Stage 1 (“satellite”): summarise the repo in ≤ 300 tokens
    * languages, frameworks, build & CI systems, entry points
- Stage 2 (“districts”): for each top‑level module/package, produce
    * a 120‑token blurb + main public APIs
- Stage 3 (“street view”): spotlight the 5 files with highest
    * centrality in the graph (fan‑in × fan‑out) and summarise each in ≤ 80 tokens
- Context hygiene.*
    * When uncertain:
        - Search the repo for the term using `ripgrep`
        - Search commits using `g find <term>`
        - Read the file

## Deliverables
Return a report with these sections:

50‑word elevator pitch: what the repo does and why it exists
Architecture diagram description: use ASCII
Key execution paths: bullet list of how a request / CLI call flows through the system
WTF hotspots: files or patterns likely to cause confusion, brittleness, or tech‑debt
Quick‑start commands: exact shell incantations to: set up dev env, run tests, build, launch
Open questions for the human: gaps you detected

## Style
• Use precise, domain language; avoid clichés.
• Prefer first‑principles explanations over buzzwords.
• Expose hidden coupling, side effects, and TODO/FIXME clusters.
• Output in terse prose; each bullet ≤ 20 words.
• Reference file paths explicitly
