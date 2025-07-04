# Code style
- ALWAYS use type hints
- ONLY use uv NEVER pip
- use f-strings for formatting
- make all comments lowercase
- DO NOT create docstrings for functions, instead use a comment but ONLY IF:
    * the function is not self-explanatory
    * there is complex logic that needs explanation
    * explain the *why* of the function, not the *what*

# Bash commands
- uv run <file>: run a command or script
- uv add <package>: add dependencies to the project
- uv remove <package>: remove dependencies from the project
- ruff format: format python files using ruff
- ruff check: check python files using ruff
- pyrefly check: check python files using pyrefly

# Workflow
- format the code with ruff after making a series of code changes
- check the code with ruff and pyrefly after making a series of code changes
