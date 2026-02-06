---
name: python
description: Python parent skill with uv-based toolchain workflow and Python submodules (FastAPI, JX, testing, HTTP client, TUI, and CLI).
---

# Python Skill

Use this parent skill when writing, reviewing, or validating Python codebases.

## Documentation

- Python Docs: <https://docs.python.org/3/>
- uv Docs: <https://docs.astral.sh/uv/>
- uv LLMs: <https://docs.astral.sh/uv/llms.txt>
- Ruff Docs: <https://docs.astral.sh/ruff/>
- Ruff LLMs: <https://docs.astral.sh/ruff/llms.txt>
- pytest Docs: <https://docs.pytest.org/>
- Rich Docs: <https://rich.readthedocs.io/en/stable/>

## Python Submodules

Use Python submodules from this folder for framework-specific guidance:

- `.agent/skills/python/fastapi/SKILL.md` (includes FastStream event-driven patterns)
- `.agent/skills/python/jx/SKILL.md`
- `.agent/skills/python/pytest/SKILL.md`
- `.agent/skills/python/httpx/SKILL.md`
- `.agent/skills/python/textual/SKILL.md`
- `.agent/skills/python/typer/SKILL.md`

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
- Framework submodule routing (FastAPI, JX)
- Event-driven backend guidance via FastAPI companion (`fastapi/faststream.md`)
- Python ecosystem modules for HTTP integrations, TUIs, and CLIs

## Code Conventions

- `pathlib` over `os.path`
- f-strings only (avoid `.format()`)
- Prefer early returns over deep nesting
- Avoid mutable global state
- Never use `print` for application logs; use `logging`

## Logging and Console Output

### Rules

- Use the stdlib `logging` module as the default logging API.
- Avoid `print` in application/library code.
- Configure logging once at the entrypoint (`main.py`, CLI bootstrap, app startup).
- Use `RichHandler` for readable local/dev logs.
- Keep `print` only for very simple throwaway scripts.

### Install (recommended)

```bash
uv add rich
```

### Module-level Logger Pattern

```python
import logging

logger = logging.getLogger(__name__)


def run_job(job_id: str) -> None:
    logger.info("Starting job", extra={"job_id": job_id})
```

### Entrypoint Logging Setup with Rich

```python
import logging
from rich.logging import RichHandler


def configure_logging(level: int = logging.INFO) -> None:
    logging.basicConfig(
        level=level,
        format="%(message)s",
        datefmt="[%X]",
        handlers=[RichHandler(rich_tracebacks=True, markup=True)],
    )
```

### CLI Output vs Logs

- Use `logging` for operational logs (`debug/info/warning/error`).
- Use `rich.console.Console` for user-facing CLI output (tables, progress, success/error messages).

```python
import logging
from rich.console import Console

logger = logging.getLogger(__name__)
console = Console()

console.print("[bold green]Done[/bold green]")
logger.info("Command finished", extra={"command": "sync"})
```

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
