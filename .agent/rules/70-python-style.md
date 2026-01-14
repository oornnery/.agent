---
name: python-style
description: Python coding conventions. Use when writing or reviewing Python code.
---

# Python style (repo-specific)
- pathlib > os.path
- f-strings only
- early returns (avoid deep nesting)
- no mutable global state
- logging > print
- modern typing: str | None, list[str]
- asyncio only: never block the event loop
