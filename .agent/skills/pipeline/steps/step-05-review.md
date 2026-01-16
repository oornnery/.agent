# Step 05 — REVIEW (Self-PR Review)

## Goal
Act like a strict teammate reviewing your own PR.

## Review Mindset

> "Would I approve this if someone else wrote it?"

Be honest, thorough, and critical.

## Review Checklist

### Correctness
- [ ] Edge cases handled?
- [ ] Null/empty inputs handled?
- [ ] Error states covered?
- [ ] Race conditions possible?

### Readability
- [ ] Would a new dev understand this?
- [ ] Clear naming?
- [ ] Comments where needed (and only where needed)?
- [ ] Logical code organization?

### Architecture
- [ ] Consistent with repo patterns?
- [ ] Proper separation of concerns?
- [ ] Dependencies flow correctly?
- [ ] No circular imports?

### API Contracts
- [ ] Stable interface?
- [ ] Documented changes?
- [ ] Backwards compatible?
- [ ] Proper error responses?

### Error Handling
- [ ] Meaningful error messages?
- [ ] Proper exception types?
- [ ] Errors logged appropriately?
- [ ] User-facing errors helpful?

### Security
- [ ] No hardcoded secrets?
- [ ] No sensitive data in logs?
- [ ] Input validation?
- [ ] Proper authorization checks?

### Performance
- [ ] No obvious N+1 queries?
- [ ] No unnecessary loops?
- [ ] Efficient data structures?
- [ ] Proper caching if needed?

### Tests
- [ ] Critical paths covered?
- [ ] Edge cases tested?
- [ ] Error paths tested?
- [ ] No flaky tests introduced?

## Issue Classification

| Severity | Description | Action |
|----------|-------------|--------|
| MUST FIX | Bugs, security issues, breaking changes | Block PR |
| SHOULD FIX | Code smells, missing tests, unclear code | Fix before merge |
| NICE TO HAVE | Style preferences, minor improvements | Optional |

## Review Output Format

```markdown
## Review Summary

**Overall**: Ready with minor fixes | Needs work | Blocked

### MUST FIX (blocking)
1. [File:Line] Issue description
   - Recommendation

### SHOULD FIX
1. [File:Line] Issue description
   - Recommendation

### NICE TO HAVE
1. [File:Line] Suggestion
```

## Output (APEX_STATE)

```json
{
  "current_step": "step-05-review",
  "review_issues": [
    {
      "description": "Missing null check",
      "severity": "must_fix",
      "file": "src/service.py",
      "line": 42,
      "resolved": false
    }
  ],
  "next_step": "step-06-resolve"
}
```
