---
name: uv-python
description: Astral's uv tool for Python package management, script execution with inline dependencies (PEP 723), project creation, and virtual environment management. Use when working with Python projects, installing packages, running scripts with dependencies, or managing Python environments.
---

# uv Python Tool

Fast Python package and project manager from Astral. Written in Rust, replaces pip, pip-tools, pipx, poetry, pyenv, and virtualenv.

## Core Mental Model

**uv is pip + venv + pyenv combined**. It handles three layers:
1. **Python versions** - installs and manages Python interpreters
2. **Environments** - creates isolated dependency spaces
3. **Packages** - resolves and installs dependencies

Key insight: uv caches aggressively and resolves in parallel. Operations that take pip minutes take uv seconds.

## Script Dependencies (PEP 723)

**The killer feature**: inline dependency declarations for single-file scripts.

### Basic Pattern

```python
# /// script
# dependencies = [
#   "requests",
#   "pandas>=2.0",
# ]
# ///

import requests
import pandas as pd

# Your code here
```

Run with:
```bash
uv run script.py
```

uv automatically:
1. Creates ephemeral venv
2. Installs declared dependencies
3. Executes script
4. Caches environment for next run

### Advanced Dependency Headers

```python
# /// script
# dependencies = [
#   "httpx>=0.24",
#   "pydantic==2.0.0",  # exact version
#   "numpy; python_version >= '3.11'",  # conditional
# ]
# requires-python = ">=3.11"
# ///
```

Specify Python version:
```bash
uv run --python 3.11 script.py
```

### Multi-File Scripts

For scripts with local imports, structure matters:

```
project/
├── main.py  # with dependency header
└── utils.py
```

Run from project directory:
```bash
uv run main.py
```

uv includes current directory in Python path.

## Project Management

### Initialize Project

```bash
# New project with structure
uv init myproject
cd myproject

# Creates:
# myproject/
# ├── pyproject.toml
# ├── .python-version
# └── src/myproject/__init__.py
```

### Add Dependencies

```bash
uv add requests pandas

# Dev dependencies
uv add --dev pytest ruff

# Specific versions
uv add "numpy>=1.20,<2.0"

# Extras
uv add "fastapi[standard]"
```

Dependencies write to `pyproject.toml` and lock to `uv.lock`.

### Remove Dependencies

```bash
uv remove requests
```

### Sync Environment

```bash
# Install all dependencies from pyproject.toml
uv sync

# Install with extras
uv sync --extra dev

# Install all extras
uv sync --all-extras
```

## Virtual Environments

### Create Venv

```bash
uv venv

# Specific Python version
uv venv --python 3.11

# Custom location
uv venv .venv-custom
```

### Activate

```bash
source .venv/bin/activate  # Linux/Mac
.venv\Scripts\activate     # Windows
```

Or skip activation:
```bash
uv run python script.py
uv run pytest
```

## Package Installation

### Install Packages

```bash
# Into active venv or auto-create one
uv pip install requests pandas

# Specific version
uv pip install "numpy==1.24.0"

# From requirements.txt
uv pip install -r requirements.txt

# Editable local package
uv pip install -e .
```

### Freeze Dependencies

```bash
uv pip freeze > requirements.txt
```

## Python Version Management

```bash
# List available Python versions
uv python list

# Install specific version
uv python install 3.11

# Set project Python version
uv python pin 3.11
# Creates .python-version file
```

## Running Tools

```bash
# Run tool without installing globally
uv tool run ruff check .
uv tool run black .

# Install tool globally
uv tool install ruff

# Update tool
uv tool upgrade ruff
```

## Key Workflows

### Workflow 1: Quick Script
```bash
# Create script with dependencies
cat > analyze.py << 'EOF'
# /// script
# dependencies = ["pandas", "matplotlib"]
# ///
import pandas as pd
import matplotlib.pyplot as plt
# ...
EOF

# Run directly
uv run analyze.py
```

### Workflow 2: New Project
```bash
uv init myapp
cd myapp
uv add fastapi uvicorn
uv run uvicorn myapp:app
```

### Workflow 3: Legacy Project Migration
```bash
# Has requirements.txt
uv venv
uv pip install -r requirements.txt

# Convert to modern project
uv init --lib
# Manually move code to src/
uv add $(cat requirements.txt)
```

## Hidden Assumptions

1. **uv.lock is the source of truth** for exact versions. pyproject.toml specifies ranges, lock file pins them. Commit both.

2. **Ephemeral environments are cheap** with uv's caching. Don't hesitate to use `uv run` for one-off scripts.

3. **No pip search** - uv intentionally omits this. Use PyPI website instead.

4. **--system-python flag** accesses system Python instead of managed versions. Rarely needed.

5. **Platform-specific locks** - uv.lock includes hashes for all platforms. One lock file works across Linux/Mac/Windows.

## Troubleshooting

### Dependency Resolution Fails
```bash
# See detailed resolution steps
uv add --verbose requests

# Try lower Python version
uv python pin 3.10
uv add requests
```

### Cache Issues
```bash
# Clear cache
uv cache clean

# Check cache size
uv cache dir
```

### Script Not Finding Imports
Ensure current directory structure:
```bash
# Wrong
uv run ../script.py

# Right
cd parent && uv run script.py
```

## Migration Paths

### From pip + venv
```bash
# Old
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# New
uv venv
uv pip install -r requirements.txt
# Or: uv sync (after converting to pyproject.toml)
```

### From Poetry
```bash
# uv reads pyproject.toml directly
uv sync

# Remove poetry.lock, keep uv.lock instead
```

## Command Cheatsheet

| Task | Command |
|------|---------|
| Create project | `uv init myproject` |
| Add dependency | `uv add requests` |
| Add dev dependency | `uv add --dev pytest` |
| Remove dependency | `uv remove requests` |
| Install all deps | `uv sync` |
| Run script | `uv run script.py` |
| Run with deps | `uv run --with pandas script.py` |
| Create venv | `uv venv` |
| Install Python | `uv python install 3.11` |
| Set Python version | `uv python pin 3.11` |
| Run tool once | `uv tool run black .` |
| Install tool | `uv tool install ruff` |
| Clear cache | `uv cache clean` |

