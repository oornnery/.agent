# Step 04 — VALIDATE (Local Confidence)

## Goal
Prove the change is correct before review.

## Minimum Validation Checklist

| Check | Required | Command |
|-------|----------|---------|
| Format | ✅ | Stack-specific |
| Lint | ✅ | Stack-specific |
| Typecheck | If exists | Stack-specific |
| Unit tests | ✅ | Relevant subset |

## Stack-Specific Commands

### Python (uv + ruff + ty + pytest)
```bash
uv run ruff format .
uv run ruff check . --fix
uv run ty check
uv run pytest -v -x  # stop on first failure
```

### Node (pnpm)
```bash
pnpm format
pnpm lint
pnpm typecheck
pnpm test
```

### Go
```bash
go fmt ./...
go vet ./...
golangci-lint run
go test ./...
```

### Rust
```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

## Handling Failures

### If Format Fails
```bash
# Auto-fix
uv run ruff format .
```

### If Lint Fails
```bash
# Try auto-fix first
uv run ruff check . --fix --unsafe-fixes

# If still failing, analyze and fix manually
```

### If Typecheck Fails
- Read error message carefully
- Fix type annotations
- Add type: ignore only as last resort (with comment)

### If Tests Fail
- **Do not ignore**
- Diagnose root cause
- Fix the issue
- Re-run the failing test

## Validation Report

```markdown
## Validation Results

| Check | Status | Notes |
|-------|--------|-------|
| Format | ✅ Pass | |
| Lint | ✅ Pass | |
| Typecheck | ✅ Pass | |
| Tests | ✅ Pass | 47 passed, 0 failed |
```

## Output (PIPELINE_STATE)

```json
{
  "current_step": "step-04-validate",
  "lint_status": "pass",
  "typecheck_status": "pass",
  "test_status": "pass",
  "commands_run": [
    "uv run ruff format .",
    "uv run ruff check .",
    "uv run ty check",
    "uv run pytest -v"
  ],
  "next_step": "step-05-review"
}
```

## Blockers

If validation fails repeatedly:
1. Document the failure
2. Attempt fix (max 3 iterations)
3. If still failing, escalate with detailed error log
