---
name: test-runner
description: Test execution, coverage analysis, and test failure debugging. Use for running tests, analyzing results, and fixing failures.
---

# Test Runner Skill

Execute tests and analyze results.

## Test Commands by Stack

### Python (pytest)
```bash
# Quick run
uv run pytest -v -x

# With coverage
uv run pytest -v --cov=src --cov-report=term-missing

# Specific file/test
uv run pytest tests/test_module.py -v
uv run pytest -k "test_name" -v

# Parallel
uv run pytest -n auto
```

### Node (pnpm)
```bash
# Quick run
pnpm test

# Watch mode
pnpm test --watch

# Coverage
pnpm test --coverage
```

### Go
```bash
# Quick run
go test ./...

# Verbose
go test -v ./...

# Coverage
go test -cover ./...
```

### Rust
```bash
# Quick run
cargo test

# Verbose
cargo test -- --nocapture
```

## Analyzing Failures

### Read the Error
```
1. What failed? (test name)
2. What was expected?
3. What was actual?
4. Where? (file:line)
```

### Common Causes

| Symptom | Likely Cause |
|---------|--------------|
| AssertionError | Logic bug |
| TypeError | Wrong type passed |
| AttributeError | Missing attribute |
| Timeout | Infinite loop or slow I/O |
| Flaky | Race condition |

### Fix Strategy
```
1. Reproduce locally
2. Add minimal debug logging
3. Identify root cause
4. Fix the issue (not just the test)
5. Verify fix works
6. Remove debug logging
```

## Coverage Analysis

### Interpreting Results
```
Name                    Stmts   Miss  Cover   Missing
-----------------------------------------------------
src/auth.py               45     12    73%     23-35, 67
src/users.py             120      5    96%     45, 89-92
-----------------------------------------------------
TOTAL                    165     17    90%
```

### Coverage Goals
| Type | Target |
|------|--------|
| Unit | > 80% |
| Integration | Key flows |
| E2E | Critical paths |

## Test Quality Checklist

- [ ] Tests describe behavior, not implementation
- [ ] No shared mutable state
- [ ] No sleep/time dependencies
- [ ] Fast execution (< 1s per test)
- [ ] Clear assertions with good messages
