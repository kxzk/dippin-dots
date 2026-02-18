---
name: uv-inline-script
description: Author and run single-file Python scripts with PEP 723 inline dependency blocks using `uv`.
---

# uv Inline Scripts

Embed dependencies directly in a script file with PEP 723 metadata.

## Inline dependency block

```python
# /// script
# dependencies = ["requests", "pandas>=2.0"]
# requires-python = ">=3.11"
# ///

import requests
import pandas as pd
```

## Useful commands

- `uv init --script example.py --python 3.12`
- `uv add --script example.py 'requests<3'`
- `uv run script.py`
- `uv run --python 3.12 script.py`
- `uv run --with httpx script.py`
