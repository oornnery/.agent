---
name: testing
description: Cross-stack validation gate workflow for test planning, execution order, failure triage, and reporting.
---

# Testing Skill

Use this skill as the cross-stack validation orchestrator.

## Scope

- Define validation gates and execution order
- Select stack commands from canonical stack skills
- Standardize failure triage and rerun strategy
- Produce structured validation output for handoff/gates

## Canonical Stack Command Sources

- Python: `.agent/skills/python/SKILL.md`
- Node: `.agent/skills/node/SKILL.md`
- Go: `.agent/skills/go/SKILL.md`
- Rust: `.agent/skills/rust/SKILL.md`

For deep Python testing setup and pytest ecosystem details, load:

- `.agent/skills/python/pytest/SKILL.md`

## Validation Gate Workflow

1. Detect stack from lock/config files.
2. Run format checks.
3. Run lint/static analysis.
4. Run type/compile checks when applicable.
5. Run tests and coverage when required.
6. If any check fails, triage root cause and rerun required scope.
7. Finish only when gate criteria pass.

## Failure Triage Policy

- Reproduce with smallest failing scope first.
- Use deterministic reruns (`--lf`, targeted test path, targeted package/module).
- Capture concise failure tails and stack trace context.
- Avoid broad retries before identifying root cause.

## Output Contract

```json
{
  "validation_passed": true,
  "stack": "python|node|go|rust",
  "format_status": "pass|fail|skipped",
  "lint_status": "pass|fail|skipped",
  "typecheck_status": "pass|fail|skipped",
  "test_status": "pass|fail|skipped",
  "coverage": {
    "lines": 0,
    "branches": 0
  },
  "commands_run": [
    "<format>",
    "<lint>",
    "<typecheck>",
    "<test>"
  ],
  "notes": "root cause, reruns, and residual risk"
}
```

## Guardrails

- Never mark gate as passed with failing mandatory checks.
- Keep local validation aligned with CI.
- Keep command source-of-truth in stack skills.
