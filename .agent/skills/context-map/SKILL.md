---
name: context-map
description: Fast repository indexing for RLM workflows. Use before analysis to reduce context drift.
---

# Context Map Skill

Create a lightweight index of the repository structure without reading full file contents.

## Usage

```bash
context-map [path]   # Generate index for path (default: current repo)
```

## Output Format

```json
{
  "generated_at": "2024-01-15T12:00:00Z",
  "entrypoints": ["app/main.py", "cli.py"],
  "core_modules": ["domain/", "services/", "infra/"],
  "tests": ["tests/"],
  "hotspots": ["billing/", "auth/"],
  "config_files": ["pyproject.toml", ".env.example"],
  "commands": {
    "format": "uv run ruff format .",
    "lint": "uv run ruff check .",
    "test": "uv run pytest -v",
    "typecheck": "uv run ty check"
  }
}
```

## Mapping Process

### 1. Structure Scan
- List top-level directories
- Identify source, tests, config, docs

### 2. Entry Point Detection
- Find `main.py`, `app.py`, `cli.py`
- Find `__main__.py` in packages
- Check pyproject.toml for scripts

### 3. Hotspot Identification
- Modules with most recent changes (git log)
- Modules with most files/lines
- Commonly referenced modules (grep imports)

### 4. Command Detection
- Parse pyproject.toml (scripts, taskipy)
- Parse Makefile targets
- Parse package.json scripts

## Integration with Pipeline

Use at Step 00 (Init) or Step 01 (Analyze):

```markdown
## Before Analysis

1. Run `context-map` on repo root
2. Use output to guide MAP phase
3. Focus DRILL on hotspots + relevant modules
```

## Best Practices

- Generate once per session, refresh if changing branches
- Use as input for step-01-analyze.md
- Combine with explorer skill for deeper dives
