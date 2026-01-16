---
name: git-workflow
description: Git branch, commit, and PR management. Use for version control operations and maintaining clean git history.
---

# Git Workflow Skill

Maintain clean git history with consistent conventions.

## Branch Naming

### Format
```
<type>/<slug>
```

### Types
| Type | Use For |
|------|---------|
| `feat/` | New features |
| `fix/` | Bug fixes |
| `refactor/` | Code improvements |
| `chore/` | Tooling, deps, CI |
| `docs/` | Documentation |
| `test/` | Test additions |

### Slug Rules
- kebab-case
- Max 50 characters
- Include ticket ID if available

### Examples
```bash
feat/add-user-auth
fix/null-pointer-login
feat/ABC-123-payment-flow
refactor/extract-validation
```

## Commit Messages

### Format
```
<type>(<scope>): <summary>

[optional body]

[optional footer]
```

### Types
| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change (no feature/fix) |
| `docs` | Documentation |
| `test` | Test changes |
| `chore` | Build, CI, deps |
| `perf` | Performance |
| `style` | Formatting |

### Rules
- Imperative mood ("add" not "added")
- Lowercase first letter
- No period at end
- Max 50 chars for summary
- Body wraps at 72 chars

### Examples
```bash
feat(auth): add JWT token validation

fix(api): handle null response from service

refactor(db): extract query builder

test(users): add creation edge cases

chore(deps): update ruff to v0.8
```

## Common Operations

### Start Feature
```bash
git checkout main
git pull --ff-only
git checkout -b feat/my-feature
```

### Save Progress
```bash
git add -p  # Interactive staging
git commit -m "feat(scope): description"
```

### Update from Main
```bash
git fetch origin main
git rebase origin/main
```

### Clean Up Commits
```bash
git rebase -i origin/main
# squash fixups, reword messages
```

### Push & PR
```bash
git push -u origin feat/my-feature
gh pr create --fill
```

## PR Description

```markdown
## Summary
- Key change 1
- Key change 2

## Motivation
Why this change exists

## Changes
### Area 1
- Detail

## How to Test
1. Step 1
2. Step 2

## Risk
- Level: Low/Medium/High
- Notes: [any concerns]
```
