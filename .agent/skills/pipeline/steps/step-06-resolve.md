# Step 06 — RESOLVE (Fix Issues from Review)

## Goal
Apply fixes from review in priority order.

## Resolution Strategy

### Priority Order
1. **MUST FIX** — Do these first, no exceptions
2. **SHOULD FIX** — Do these before marking complete
3. **NICE TO HAVE** — Only if time permits and low risk

## Resolution Process

For each issue:

```
1. Understand the issue
2. Identify the fix
3. Apply minimal change
4. Verify fix works
5. Re-run validation
6. Mark as resolved
```

## Rules

### Keep Fixes Minimal
- Fix only what was identified
- Don't expand scope
- One fix per issue

### Re-validate After Fixes
```bash
# After each MUST FIX
uv run ruff check .
uv run pytest -v -x

# After all fixes
Full validation (step-04)
```

### Document Decisions
If you choose NOT to fix something, explain why:
- "Deferred: requires larger refactor, tracked in #123"
- "Won't fix: existing pattern in codebase"

## Issue Resolution Tracking

```markdown
## Resolution Status

### MUST FIX
- [x] #1: Missing null check — Fixed in `service.py:42`
- [x] #2: SQL injection risk — Fixed with parameterized query

### SHOULD FIX
- [x] #1: Unclear variable name — Renamed `x` to `user_count`
- [ ] #2: Missing docstring — Deferred to follow-up

### NICE TO HAVE
- [ ] #1: Could use list comprehension — Skipped
```

## Output (APEX_STATE)

```json
{
  "current_step": "step-06-resolve",
  "review_issues": [
    {
      "description": "Missing null check",
      "severity": "must_fix",
      "file": "src/service.py",
      "line": 42,
      "resolved": true
    }
  ],
  "files_touched": ["src/service.py"],
  "commands_run": ["uv run pytest -v -x"],
  "next_step": "step-07-tests"
}
```

## Escalation

If a MUST FIX issue cannot be resolved:
1. Document the blocker clearly
2. Explain what was tried
3. Request guidance (if interactive mode)
4. Do not proceed to PR with unresolved MUST FIX
