# Code style
- ONLY use uv NEVER pip
- Fully type hint all functions
- F‑strings everywhere
- Use f"{variable=}" format when debugging
- Use builtin types for type hints (int, str, list, dict, set, tuple) not typing.List, typing.Dict, etc...

# Documentation
- NO docstrings
- Minimal inline comments; reserve for why, never what
- Let types and names document intent

# UV usage
- `uv run <file>`: run a command or script
## Scripts
- `uv run --with <package> <file>`: file with a specific package
- `uv add --script <file> '<package1>' '<package2>'`: add dependencies to a script
- `uvx <package>`: run a package without installing it
## Projects
- `uv init <project_name>`: initialize a new project
- `uv add <package>`: add dependency to the project
- `uv remove <package>`: remove dependency from the project
- `uv sync`: update project's environment
- `uv venv`: create a virtual environment
## Tools
- `uv tool run <tool_name>`: run a tool
- `uv tool install <tool_name>`: install a tool
- `uv tool uninstall <tool_name>`: uninstall a tool

# Bash commands
- `uvx ty check`: check python files using ty

# Workflow
- check the code with `ty` after making a series of code changes
