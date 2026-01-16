# Commit Message Format

## Structure

```
<type>(<scope>): <summary>

[optional body]

[optional footer]
```

## Types

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

## Scope

Optional, indicates the area of change:
- `auth`, `api`, `db`, `ui`, `core`, etc.

## Summary

- Imperative mood ("add" not "added")
- Lowercase first letter
- No period at end
- Max 50 characters

## Examples

```
feat(auth): add JWT token validation

fix(api): handle null response from external service

refactor(db): extract query builder to separate module

test(users): add integration tests for user creation

chore(deps): update ruff to v0.8.0
```

## Body (optional)

- Explain what and why (not how)
- Wrap at 72 characters
- Separate from summary with blank line

```
feat(billing): add retry logic for failed payments

Payments were failing silently when the payment gateway
returned a timeout. This adds exponential backoff retry
with max 3 attempts before marking as failed.

Closes #123
```

## Footer (optional)

- Breaking changes: `BREAKING CHANGE: description`
- Issue references: `Closes #123`, `Fixes #456`
