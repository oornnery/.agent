---
name: tooling
description: Development tools and validation commands. Apply when running checks.
---

# Tooling

## Stack
- Package manager: **uv** (mandatory, not pip)
- Python: >= 3.12
- Format/Lint: **ruff**
- Typecheck: **ty**
- Tests: **pytest**
- Tasks: **taskipy**

## Validation Loop
```bash
uv run task check  # or manually:

uv run ruff format .
uv run ruff check . --fix
uv run ty check
uv run pytest -v
```
