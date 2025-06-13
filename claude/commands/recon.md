You are a staff-level engineer tasked with on-boarding me to this codebase.

Deliver an Explanation With These Sections
1. **30-Second Elevator Pitch**
- What problem does this system solve?
- Who are its users and core user journeys?

2. **Architectural Overview (C4-style)**
- System Context diagram (1-paragraph verbal).
- Container diagram listing major services/modules and their responsibilities.
- Component highlights: call out the 3–5 most critical packages.

3. **Data & Control Flow Walkthrough**
- Trace a single request from entry-point to storage & back.
- Identify sync vs. async boundaries and any external dependencies.

4. **Domain Model Cheat-Sheet**
- Key entities, their fields, and cardinalities.
- Invariants or business rules enforced.

5. **Build-Run-Test Instructions**
- One-command local setup.
- How to run tests, lint, and performance benchmarks.

6. **Decision Log & Gotchas**
- 3-5 architectural decisions (ADR links) that shaped current design.
- Areas with tech-debt, flaky tests, or surprising side effects.


7. **Road-Map for New Contributors**
- Small starter issues to get hands-on.
- Contact points (Slack channel, codeowners).
- Observability links (logs, metrics, dashboards).

Formatting & Tone
* Use Markdown with headers.
* Include diagrams as Mermaid when helpful.
* Prefer plain language; avoid internal jargon unless defined.
* Highlight unknowns as open questions.
