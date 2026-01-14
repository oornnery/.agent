---
name: tooling-workflows
description: Development tools and validation commands. Use when running checks, formatting, or managing dependencies.
---

# Tooling (authoritative)
- Use uv (mandatory). Do NOT use pip/poetry.
- Python >= 3.12
- Format/Lint: ruff
- Typecheck: ty
- Tests: pytest
- Task runner: taskipy

## Validation loop (run after meaningful changes)
```bash
uv run ruff format .
uv run ruff check . --fix --unsafe-fixes
uv run ty check src tests
uv run pytest -v
```

## uv/uvx cookbook (examples)
```bash
uv sync
uv add <pkg>
uv add --dev <pkg>

uvx --from ruff ruff format .
uvx --from ruff ruff check . --fix
uvx --from ty ty check src tests
```

## httpx-cli discovery
```bash
uvx --from httpx httpx https://api.example.com
uvx --from httpx httpx https://api.example.com -H "Accept: application/json"
uvx --from httpx httpx https://api.example.com -m POST -j '{"ok": true}'
```
