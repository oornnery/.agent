# Stack: Python (uv + ruff + ty + pytest)

## Package Manager
- **Tool**: uv
- **Lock file**: `uv.lock`
- **Config**: `pyproject.toml`

## Commands

### Install Dependencies
```bash
uv sync
```

### Add Package
```bash
uv add <package>
uv add --dev <package>
```

### Format
```bash
uv run ruff format .
```

### Lint
```bash
uv run ruff check .
uv run ruff check . --fix
uv run ruff check . --fix --unsafe-fixes
```

### Typecheck
```bash
uv run ty check
# or specific paths
uv run ty check src tests
```

### Run Tests
```bash
# Quick run
uv run pytest -v -x

# Full run with coverage
uv run pytest -v --cov=src --cov-report=term-missing

# Specific test file
uv run pytest tests/test_specific.py -v
```

### Task Runner (taskipy)
```bash
# Run defined tasks
uv run task lint
uv run task format
uv run task test
uv run task check   # all checks
```

**pyproject.toml config:**
```toml
[tool.taskipy.tasks]
format = "ruff format ."
lint = "ruff check . --fix"
typecheck = "ty check"
test = "pytest -v"
check = "task format && task lint && task typecheck && task test"
dev = "uvicorn app.main:app --reload"
```

### Run Application
```bash
# Module
uv run python -m app.main

# Script
uv run python scripts/run.py

# With uvicorn (FastAPI)
uv run uvicorn app.main:app --reload
```

## CI Pipeline (GitHub Actions)

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
      - run: uv sync
      - run: uv run ruff format --check .
      - run: uv run ruff check .
      - run: uv run ty check
      - run: uv run pytest -v
```

## File Structure

```
project/
├── pyproject.toml
├── uv.lock
├── src/
│   └── app/
│       ├── __init__.py
│       └── main.py
├── tests/
│   ├── __init__.py
│   └── test_main.py
└── .python-version
```

## pyproject.toml Configuration

```toml
# ============================================
# RUFF - Formatter & Linter
# ============================================
[tool.ruff]
target-version = "py312"
line-length = 100
src = ["src", "tests"]

[tool.ruff.lint]
select = [
    "E",      # pycodestyle errors
    "W",      # pycodestyle warnings
    "F",      # pyflakes
    "I",      # isort
    "B",      # flake8-bugbear
    "C4",     # flake8-comprehensions
    "UP",     # pyupgrade
    "ARG",    # flake8-unused-arguments
    "SIM",    # flake8-simplify
    "PTH",    # flake8-use-pathlib
    "RUF",    # ruff-specific rules
]
ignore = [
    "E501",   # line too long (handled by formatter)
    "B008",   # do not perform function calls in argument defaults
]

[tool.ruff.lint.isort]
known-first-party = ["app"] # Add your project name here

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
skip-magic-trailing-comma = false

# ============================================
# TY - Type Checker
# ============================================
[tool.ty]
basic = true
src = ["src"] # Add your project name here

# ============================================
# PYTEST
# ============================================
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_functions = ["test_*"]
addopts = [
    "-v",
    "--strict-markers",
    "--tb=short",
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
]

[tool.coverage.run]
source = ["src"]
branch = true
omit = ["*/tests/*", "*/__init__.py"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "if TYPE_CHECKING:",
    "raise NotImplementedError",
]

# ============================================
# TASKIPY - Task Runner
# ============================================
[tool.taskipy.tasks]
format = "ruff format ."
lint = "ruff check . --fix"
typecheck = "ty check"
test = "pytest"
cov = "pytest --cov --cov-report=term-missing"
check = "task format && task lint && task typecheck && task test"
dev = "uvicorn app.main:app --reload"
```

