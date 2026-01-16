# Step 08 — VERIFY TESTS (Full Suite / CI Parity)

## Goal
Ensure the full test pipeline passes, matching CI behavior.

## Actions

### 1. Run Full Test Suite
Use the same command CI uses:

```bash
# Python (uv + pytest)
uv run pytest -v --tb=short

# Node (pnpm)
pnpm test

# Go
go test ./... -v

# Rust
cargo test
```

### 2. Verify All Checks Pass

| Check | Command | Status |
|-------|---------|--------|
| Format | `uv run ruff format --check .` | |
| Lint | `uv run ruff check .` | |
| Typecheck | `uv run ty check` | |
| Tests | `uv run pytest -v` | |

### 3. Check for Warnings
- No deprecation warnings
- No type warnings
- No uncaught exceptions in logs

## CI Parity Checklist

- [ ] Same Python/Node/Go version as CI
- [ ] Same test command as CI
- [ ] All environment variables set
- [ ] Database migrations applied (if applicable)

## Handling Failures

### Test Failure
```
1. Read the failure message
2. Identify root cause (your code or test issue)
3. Fix the issue
4. Re-run just that test first
5. Re-run full suite
```

### Flaky Test Detection
If a test passes sometimes and fails others:
- Mark as flaky issue
- Investigate async/timing issues
- Fix or skip with comment

## Test Run Report

```markdown
## Test Verification

**Environment**: Python 3.12, pytest 8.x
**Command**: `uv run pytest -v`

### Results
- Total: 156 tests
- Passed: 156
- Failed: 0
- Skipped: 2 (marked xfail)

### Coverage (if available)
- Lines: 87%
- Branches: 72%
- New code: 100%

### Warnings
- None
```

## Output (PIPELINE_STATE)

```json
{
  "current_step": "step-08-run-tests",
  "test_status": "pass",
  "lint_status": "pass",
  "typecheck_status": "pass",
  "commands_run": [
    "uv run ruff format --check .",
    "uv run ruff check .",
    "uv run ty check",
    "uv run pytest -v"
  ],
  "next_step": "step-09-finish"
}
```

## Blocking Criteria

Do NOT proceed to finish if:
- Any test fails
- Lint errors present
- Type errors present
- Unhandled warnings

Fix all issues before continuing.
