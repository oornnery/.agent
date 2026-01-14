---
name: testing
description: Testing guidelines. Use when writing or running tests.
---

# Testing
- Run: `uv run pytest -v`
- Prefer real implementations; mock only external APIs.
- Cover happy path + failure path; tests must be deterministic.
