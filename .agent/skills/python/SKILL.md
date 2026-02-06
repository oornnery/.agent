---
name: python
description: Python parent skill with uv-based toolchain workflow and Python submodules (FastAPI, JX, FastStream).
---

# Python Skill

Use this parent skill when writing, reviewing, or validating Python codebases.

## Python Submodules

Use Python submodules from this folder for framework-specific guidance:

- `.agent/skills/python/fastapi/SKILL.md`
- `.agent/skills/python/jx/SKILL.md`
- `.agent/skills/python/faststream/SKILL.md`
- `.agent/skills/python/test-runner/SKILL.md`

## Loading Order

1. Load this file for baseline Python conventions and validation commands.
2. Load one or more submodules based on stack/framework detection.
3. Prefer submodule-specific guidance over generic advice when conflicts appear.

## Scope

- Python coding conventions
- Type hints and async boundaries
- uv dependency and environment management
- Validation pipeline (format, lint, typecheck, test)
- CI parity for Python projects
- Framework submodule routing (FastAPI, JX, FastStream)

## Code Conventions

- `pathlib` over `os.path`
- f-strings only (avoid `.format()`)
- Prefer early returns over deep nesting
- Avoid mutable global state
- Use `logging` over `print`

## Type Hints

- Use modern syntax (`str | None`, `list[str]`)
- Type all public functions
- Use `TypedDict` for dictionaries with known keys

## Async

- Use `asyncio` patterns only; never block the event loop
- Prefer `async with` for async resources
- Use `gather` with explicit error handling

## Toolchain

- Package manager: `uv`
- Lock file: `uv.lock`
- Project config: `pyproject.toml`

## Validation Sequence

1. `uv run ruff format --check .`
2. `uv run ruff check .`
3. `uv run ty check`
4. `uv run pytest -v`

Coverage variant:

- `uv run pytest -v --cov=src --cov-report=term-missing`

## Common Commands

### Setup and Dependencies

- `uv sync`
- `uv add <package>`
- `uv add --dev <package>`

### Formatting and Lint

- `uv run ruff format .`
- `uv run ruff check . --fix`
- `uv run ruff check . --fix --unsafe-fixes`

### Typecheck and Tests

- `uv run ty check src tests`
- `uv run pytest tests/test_specific.py -v`

### Run Application

- `uv run python -m app.main`
- `uv run uvicorn app.main:app --reload`

## Optional Task Runner (taskipy)

When `[tool.taskipy.tasks]` exists:

- `uv run task format`
- `uv run task lint`
- `uv run task typecheck`
- `uv run task test`
- `uv run task check`

## Guardrails

- Prefer `uv` over direct `pip` workflows.
- Keep local checks aligned with CI.
- Fail fast on lint/type errors before running full test suites.
