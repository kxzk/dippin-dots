---
name: python-oneoff
description: Write and run one-use Python scripts with external dependencies through `uv` and PEP 723 inline metadata. Use for quick scripts, short-lived automation, API probes, and data checks that need third-party packages.
---

# Python One-Use Scripts

Put dependencies directly in the script file with PEP 723 metadata.

## Inline Dependency Block

```python
# /// script
# dependencies = ["requests", "pandas>=2.0"]
# requires-python = ">=3.11"
# ///

import requests
import pandas as pd
```

## Useful Commands

- `uv init --script example.py --python 3.12`
- `uv add --script example.py 'requests<3'`
- `uv run script.py`
- `uv run --python 3.12 script.py`
- `uv run --with httpx script.py`
