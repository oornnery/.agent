---
name: test-runner
description: Complete Python testing workflow: environment setup, pytest ecosystem, test authoring, async/parallel execution, coverage, and failure diagnosis.
---

# Test Runner Skill

Set up, write, run, and debug Python tests with reliable quality gates.

> **⚠️ GATE SKILL**
> In gate mode, do not proceed if validation fails.

## Philosophy

> "Test behavior, not implementation."

## Scope

- Python test environment bootstrap
- Test dependency installation
- Test authoring patterns (unit/integration/API)
- Async tests with pytest
- Parallel execution with xdist
- Coverage collection and reporting
- Failure triage and deterministic reruns

## Canonical Stack Source

Use `.agent/skills/python/SKILL.md` as the source of truth for baseline Python toolchain commands.

## Environment Preparation

### 1) Sync project environment

```bash
uv sync
```

### 2) Install test dependencies (if missing)

Core:

```bash
uv add --dev pytest pytest-cov
```

Recommended for advanced flows:

```bash
uv add --dev pytest-asyncio pytest-xdist pytest-mock
```

Optional (property-based testing):

```bash
uv add --dev hypothesis
```

### 3) Baseline `pyproject.toml` (recommended)

```toml
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
  "slow: long-running tests",
  "integration: integration-level tests",
  "e2e: end-to-end flow tests",
]

[tool.coverage.run]
source = ["src"]
branch = true
omit = ["*/tests/*", "*/__init__.py"]

[tool.coverage.report]
show_missing = true
skip_covered = false
```

## Test Structure Guidance

Suggested layout:

```text
tests/
├── conftest.py
├── unit/
├── integration/
└── e2e/
```

Guidelines:

- Keep fixtures close to where they are used.
- Default to function-scoped fixtures for isolation.
- Avoid hidden global state between tests.
- Prefer explicit test data builders/factories.

## Test Authoring Patterns

### Unit tests

- Mock external boundaries (network, DB, filesystem).
- Keep one behavior assertion per test intent.
- Use clear assertion messages for critical expectations.

### Integration tests

- Validate real interactions between internal components.
- Isolate external systems via test containers/fakes when needed.
- Mark explicitly with `@pytest.mark.integration`.

### API/contract tests

- Validate status codes, payload shape, and error contracts.
- Verify edge cases and invalid inputs.

## Async Testing

When async code exists:

```python
import pytest

@pytest.mark.asyncio
async def test_async_flow():
    result = await service_call()
    assert result.status == "ok"
```

Guidelines:

- Do not block the event loop inside async tests.
- Use async fixtures for async resources.
- Ensure teardown closes connections cleanly.

## Execution Workflow (Python)

1. Detect stack.
2. Ensure test dependencies are installed.
3. Run fast local test pass.
4. Run full validation suite (including coverage).
5. If needed, run parallel suite.
6. If any step fails: diagnose, fix root cause, rerun relevant scope, then rerun full gate.

## Command Reference

### Fast feedback

```bash
uv run pytest -v -x
```

### Specific file/test

```bash
uv run pytest tests/unit/test_users.py -v
uv run pytest tests/unit/test_users.py::test_create_user -v
```

### By marker

```bash
uv run pytest -m "not slow" -v
uv run pytest -m integration -v
```

### Parallel execution (xdist)

```bash
uv run pytest -n auto -v
uv run pytest -n 4 --dist=loadfile -v
```

### Async-focused runs

```bash
uv run pytest -k async -v
```

### Coverage (terminal)

```bash
uv run pytest -v --cov=src --cov-report=term-missing
```

### Coverage artifacts (CI/reporting)

```bash
uv run pytest -v --cov=src --cov-branch --cov-report=xml --cov-report=html --cov-report=term-missing
```

## Conftest and Fixtures

When stack is Python, `tests/conftest.py` is the central pytest config for:

- Shared fixtures
- Hooks
- Plugins
- Markers

Prefer:

- Function-scope fixtures for isolation
- `tmp_path` for temporary files
- Deterministic tests without timing/order dependencies

## Failure Triage

### Useful debug flags

```bash
uv run pytest -vv --maxfail=1 --tb=long
uv run pytest --lf -v        # last failed
uv run pytest --ff -v        # failed first
uv run pytest -rA -v         # full summary incl. skipped/xfailed
uv run pytest --durations=10 -v  # slowest tests
```

### Failure/Log Tails

For long logs, keep the tail of the output focused on the failing test:

```bash
uv run pytest -vv --maxfail=1 --tb=long | tail -n 200
```

Guidelines:

- Capture only the failing section + immediate context.
- Include traceback tail in handoff notes.
- Prefer reproducible reruns (`--lf`, single test path) over broad reruns.

### Failure Analysis

### Read the Error

1. What failed? (test name)
2. What was expected?
3. What was actual?
4. Where? (file:line)

### Common Causes

| Symptom | Likely Cause |
|---|---|
| AssertionError | Logic bug |
| TypeError | Wrong type passed |
| AttributeError | Missing attribute |
| Timeout | Infinite loop or slow I/O |
| Flaky | Race condition |

### Fix Strategy

1. Reproduce locally.
2. Add minimal diagnostics.
3. Identify root cause.
4. Fix code (not only assertions).
5. Re-run affected checks.
6. Remove temporary diagnostics.

## Coverage Guidance

| Type | Target |
|---|---|
| Unit | > 80% |
| Integration | Key flows |
| E2E | Critical paths |

Coverage guardrails:

- Prefer branch coverage when business logic has condition-heavy paths.
- Track missing lines and justify intentional exclusions.
- Do not inflate coverage with low-value assertions.

## Test Quality Checklist

- [ ] Behavior-focused tests
- [ ] No shared mutable state
- [ ] No sleep/time coupling
- [ ] Fast and deterministic execution
- [ ] Clear assertions and failure messages
- [ ] Async tests do not block event loop
- [ ] Coverage report reviewed for real gaps

## Output Contract

```json
{
  "validation_passed": true,
  "format_status": "pass",
  "lint_status": "pass",
  "typecheck_status": "pass",
  "test_status": "pass",
  "test_results": {
    "total": 156,
    "passed": 156,
    "failed": 0,
    "skipped": 2
  },
  "coverage": {
    "lines": 87,
    "branches": 72
  },
  "commands_run": [
    "<stack-specific format command>",
    "<stack-specific lint command>",
    "<stack-specific type/compile command>",
    "<stack-specific test command>"
  ]
}
```
