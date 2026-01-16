---
name: python
description: Python coding conventions. Apply when writing or reviewing Python code.
---

# Python Style

## Code Style
- `pathlib` > `os.path`
- f-strings only (no `.format()`)
- Early returns—avoid deep nesting
- No mutable global state
- `logging` > `print`

## Type Hints
- Modern syntax: `str | None`, `list[str]`
- All public functions typed
- Use `TypedDict` for dicts with known keys

## Async
- asyncio only—never block event loop
- Use `async with` for resources
- Gather with proper error handling
