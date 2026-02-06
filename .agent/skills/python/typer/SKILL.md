---
name: python-typer
description: CLI development with Typer including command structure, typed options/arguments, async execution, and testing.
---

# Typer Skill

Use this skill when building Python command-line interfaces.

## Documentation

- Typer Docs: <https://typer.tiangolo.com/>
- Typer Tutorial: <https://typer.tiangolo.com/tutorial/>
- Testing CLIs: <https://typer.tiangolo.com/tutorial/testing/>

## Scope

- Organize commands and subcommands
- Typed arguments and options
- Input/output patterns and exit codes
- Async command integration
- CLI tests with `typer.testing.CliRunner`

## Install

```bash
uv add typer rich
```

## CLI Layout Pattern

```python
import typer

app = typer.Typer(help="Project CLI")
users = typer.Typer(help="User operations")
app.add_typer(users, name="users")
```

## Command Pattern

```python
from pathlib import Path
import typer


@users.command("import")
def import_users(
    file: Path = typer.Argument(..., exists=True, readable=True),
    dry_run: bool = typer.Option(False, "--dry-run", help="Validate without writing"),
) -> None:
    if dry_run:
        typer.echo(f"Validated file: {file}")
        raise typer.Exit(code=0)
    typer.echo(f"Imported users from: {file}")
```

## Validation and Exit Codes

```python
@app.command()
def run(env: str = typer.Option("dev")) -> None:
    if env not in {"dev", "staging", "prod"}:
        typer.echo("Invalid env", err=True)
        raise typer.Exit(code=2)
    typer.echo(f"Running in {env}")
```

## Async Integration Pattern

```python
import asyncio
import typer


@app.command()
def sync_users() -> None:
    asyncio.run(_sync_users())


async def _sync_users() -> None:
    ...
```

## Testing Pattern

```python
from typer.testing import CliRunner

runner = CliRunner()


def test_run_invalid_env() -> None:
    result = runner.invoke(app, ["run", "--env", "unknown"])
    assert result.exit_code == 2
    assert "Invalid env" in result.stdout
```

## Guardrails

- Keep commands thin and delegate business logic to services.
- Use type hints for all command params.
- Return stable exit codes for automation.
- Avoid printing secrets in stdout/stderr.
