# Step 09 — FINISH (PR-Ready Output)

## Goal
Create a high-quality PR package ready for merge.

## Pre-Flight Checklist

Before creating PR, verify:

- [ ] All checks pass (format, lint, type, tests)
- [ ] No debug prints or console.logs
- [ ] No TODOs without ticket reference
- [ ] No commented-out code
- [ ] Branch is up-to-date with base

## Git Hygiene

### 1. Review Commits
```bash
git log --oneline base..HEAD
```

Ensure commits follow convention:
- `feat(scope): description`
- `fix(scope): description`
- `refactor(scope): description`

### 2. Clean Up If Needed
```bash
# Squash fixup commits
git rebase -i base

# Update commit messages
git commit --amend
```

### 3. Push Branch
```bash
git push origin feat/your-branch
```

## PR Description

Use template from `templates/pr.md`:

```markdown
## Summary
- [1-3 bullet points of what changed]

## Motivation
- Why this change exists
- Link to issue/ticket if applicable

## Changes
### [Component 1]
- What changed

### [Component 2]
- What changed

## How to Test
1. Step 1
2. Step 2
3. Expected result

## Risk / Rollout
- **Risk Level**: Low | Medium | High
- **Rollout Notes**: [Any special deployment steps]

## Screenshots / Logs
[If applicable]

## Checklist
- [ ] Tests pass
- [ ] Docs updated (if needed)
- [ ] Breaking changes documented
```

## Create PR

### Using GitHub CLI
```bash
gh pr create \
  --title "feat(scope): description" \
  --body-file .github/pr-body.md \
  --base main
```

### Manual
1. Open GitHub/GitLab
2. Create PR from branch
3. Fill in template
4. Request reviewers

## Final Verification

After PR is created:
- [ ] CI passes
- [ ] PR description is complete
- [ ] Correct reviewers assigned
- [ ] Labels applied

## Output (APEX_STATE)

```json
{
  "current_step": "step-09-finish",
  "branch": "feat/add-user-auth",
  "commits": [
    {"hash": "abc123", "message": "feat(auth): add JWT middleware"},
    {"hash": "def456", "message": "test(auth): add auth tests"}
  ],
  "pr": {
    "title": "feat(auth): Add JWT authentication",
    "url": "https://github.com/org/repo/pull/123"
  },
  "test_status": "pass",
  "next_step": "done"
}
```

## Done Criteria

Pipeline is complete when:
- ✅ All validation checks pass
- ✅ All review issues resolved
- ✅ Tests added and passing
- ✅ PR created with complete description
- ✅ CI green

## Handoff Summary

```markdown
## APEX Complete

**Goal**: [Original goal]
**Branch**: `feat/xxx`
**PR**: [URL]

### What Changed
- [Summary of changes]

### Files Modified
- `path/to/file.py`

### Tests Added
- `tests/test_xxx.py`

### Risks
- [Any remaining risks]

### Follow-up
- [Any future work identified]
```
