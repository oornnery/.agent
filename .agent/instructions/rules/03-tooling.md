---
name: tooling
description: Development tools and validation commands. Apply when running checks.
---

# Tooling

## Principle

Always run the full validation loop for the detected stack before finalizing work.

## Canonical Command Sources (by stack)

- Validation orchestration: `.agent/skills/testing/SKILL.md`
- Python: `.agent/skills/python/SKILL.md`
- Node: `.agent/skills/node/SKILL.md`
- Go: `.agent/skills/go/SKILL.md`
- Rust: `.agent/skills/rust/SKILL.md`

## Validation Loop (generic)

1. Detect stack from lock/config files.
2. Run format checks.
3. Run lint/static analysis.
4. Run type/compile checks when applicable.
5. Run tests (and coverage when required).
6. If any check fails, fix and re-run all required checks.

## Guardrails

- Do not hardcode one stack's commands for every project.
- Keep local validation aligned with CI scripts.
- Use stack skills as source-of-truth for language/toolchain commands.
