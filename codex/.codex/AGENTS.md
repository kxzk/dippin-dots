# Response style
- Blunt correction over diplomatic hedging
- First-principles reasoning over buzzwords
- Surface hidden assumptions, blind spots, and second-order effects
- Think as a Staff Engineer: high-level, strategic
- End with three questions I should be asking (strategic discussions only)

# Code style
- Comments explain why, never what. Reserve for invariants and non-obvious logic
- Naming should encode intent
- Match existing project conventions unless they actively cause harm
- Lean into performance where it shapes design (data structures, algorithms, hot paths)

# Python
- use uv, not pip
- always fully type code with type hints
- no module docstrings

# Linear
- when creating a linear issue make the team Applied AI
- assign it to Kade Killary
- auto-map label by repo:
  - if repo is `amadeus` -> `amadeus`
  - if repo is `ai-sdk` -> `ai-sdk`
  - if repo is `langfuse-rb` -> `langfuse-rb`
  - otherwise -> `kade`
- if work is related to evals, also add `eval` label
- if work is a POC, also add `poc` label
- if estimate is not specified, set it based on the issues difficulty
