---
name: git-workflow
description: Git branch, commit, and PR conventions. Apply when creating branches, commits, rebases, or pull requests.
---

# Git Workflow

Use consistent Git hygiene to keep history reviewable and safe to integrate.

## Branch Naming

Format:

```text
<type>/<slug>
```

Types:

- `feat/` new feature
- `fix/` bug fix
- `refactor/` code structure changes without behavior change
- `chore/` tooling, dependency, CI changes
- `docs/` documentation updates
- `test/` test-only changes

Slug rules:

- kebab-case
- max 50 chars
- include ticket ID when available

## Commit Convention

Format:

```text
<type>(<scope>): <summary>
```

Rules:

- imperative mood (`add`, `fix`, `refactor`)
- lowercase start
- no trailing period
- summary max 50 chars
- optional body explains why and impact

Examples:

- `feat(auth): add jwt token validation`
- `fix(api): handle null upstream response`
- `refactor(db): extract query builder`

## Rebase and History Hygiene

- Prefer `git pull --ff-only` to avoid accidental merge commits.
- Keep branch updated with `git fetch` + `git rebase origin/main` (or default branch).
- Squash or reorder local fixup commits before PR when useful.

## PR Quality Bar

Before opening/updating PR:

1. Ensure local validation passes (format, lint, typecheck, tests).
2. Keep scope focused and explain risk/rollout impact.
3. Include reproducible test/verification steps.
4. Document breaking changes and migrations explicitly.

## Guardrails

- Do not rewrite shared branch history unless explicitly coordinated.
- Do not mix unrelated changes in the same commit.
- Prefer small, atomic commits over large snapshots.
