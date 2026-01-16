---
name: code-review
description: Self-review patterns and checklists. Use before creating PRs or when reviewing your own changes.
---

# Code Review Skill

Systematic self-review to catch issues before PR.

## Review Checklist

### Correctness
- [ ] Logic is correct for all inputs
- [ ] Edge cases handled
- [ ] Null/empty checks present
- [ ] Error states covered
- [ ] No race conditions

### Readability
- [ ] Clear naming
- [ ] Appropriate comments
- [ ] Logical organization
- [ ] No magic numbers
- [ ] Self-documenting code

### Architecture
- [ ] Follows existing patterns
- [ ] Proper separation of concerns
- [ ] No circular dependencies
- [ ] Single responsibility

### Security
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] Authorization checks
- [ ] No sensitive data in logs
- [ ] SQL injection prevention

### Performance
- [ ] No N+1 queries
- [ ] Efficient algorithms
- [ ] Proper indexing considered
- [ ] No memory leaks

### Tests
- [ ] Happy path tested
- [ ] Error paths tested
- [ ] Edge cases tested
- [ ] No flaky tests

## Issue Severity

| Level | Description | Action |
|-------|-------------|--------|
| MUST FIX | Bugs, security, breaking | Block PR |
| SHOULD FIX | Code smells, missing tests | Fix before merge |
| NICE TO HAVE | Style, minor improvements | Optional |

## Review Template

```markdown
## Review Summary

**Files reviewed**: 5
**Issues found**: 3 (1 must fix, 2 should fix)

### MUST FIX
1. **[src/auth.py:45]** Missing password validation
   - Risk: Security vulnerability
   - Fix: Add password strength check

### SHOULD FIX
1. **[src/users.py:23]** Variable name `x` unclear
   - Fix: Rename to `user_count`

2. **[tests/]** Missing test for error case
   - Fix: Add test for invalid input

### NICE TO HAVE
- Consider using list comprehension at line 67
```

## Quick Review Commands

```bash
# Check what changed
git diff --stat

# Review each file
git diff path/to/file.py

# Check for common issues
grep -r "TODO\|FIXME\|XXX" src/
```
