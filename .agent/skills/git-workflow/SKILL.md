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
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change that neither fixes nor adds |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `chore` | Build, CI, dependencies |

### Scope
Optional, indicates the area of change:
- `auth`, `api`, `db`, `ui`, `core`, etc.

### Summary Rules
- Imperative mood ("add" not "added")
- Lowercase first letter
- No period at end
- Max 50 characters

### Body (optional)
- Explain what and why (not how)
- Wrap at 72 characters
- Separate from summary with blank line

### Footer (optional)
- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Closes #123`, `Fixes #456`

### Examples
```bash
feat(auth): add JWT token validation

fix(api): handle null response from external service

refactor(db): extract query builder to separate module

test(users): add integration tests for user creation

chore(deps): update ruff to v0.8.0
```

### Example with Body
```bash
feat(billing): add retry logic for failed payments

Payments were failing silently when the payment gateway
returned a timeout. This adds exponential backoff retry
with max 3 attempts before marking as failed.

Closes #123
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

## PR Description Template

```markdown
## Summary
- [1-3 bullet points of the key changes]

## Motivation
- Why this change exists
- Link to issue/ticket: #XXX

## Changes

### [Component 1]
- What changed in this area

### [Component 2]
- What changed in this area

## How to Test

1. Pull this branch
2. Run `<setup command>`
3. Execute `<test command>`
4. Verify: [expected result]

## Risk / Rollout

| Aspect | Details |
|--------|---------|
| Risk Level | Low / Medium / High |
| Breaking Changes | Yes / No |
| Migration Required | Yes / No |
| Feature Flag | `FLAG_NAME` or N/A |
| Rollout Notes | [Special deployment steps] |

## Screenshots / Logs

[If applicable, add screenshots or relevant logs]

## Checklist

- [ ] Tests pass locally
- [ ] Lint/format clean
- [ ] Type check clean
- [ ] Docs updated (if applicable)
- [ ] Breaking changes documented
- [ ] Migration script included (if applicable)
```

## Changelog Format

### Structure
```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- New feature description

### Changed
- Change description

### Fixed
- Bug fix description

### Removed
- Removed feature description

## [1.2.0] - 2026-01-15

### Added
- Feature A
- Feature B

### Fixed
- Bug X
```

### Categories
| Category | Description |
|----------|-------------|
| Added | New features |
| Changed | Changes in existing functionality |
| Deprecated | Soon-to-be removed features |
| Removed | Removed features |
| Fixed | Bug fixes |
| Security | Vulnerability fixes |

### Guidelines
- Keep entries concise and user-focused
- Link to PRs/issues when relevant
- Use present tense ("Add" not "Added")
- Group by category, then by scope

### Example Entry
```markdown
## [2.1.0] - 2026-01-15

### Added
- JWT authentication for API endpoints (#123)
- Rate limiting with configurable thresholds (#125)

### Changed
- Improved error messages for validation failures (#124)

### Fixed
- Race condition in concurrent user creation (#126)

### Security
- Updated dependencies to patch CVE-2026-0001
```
