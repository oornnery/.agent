---
name: code-review
description: Formal code review checklist, severity policy, and reporting contract. Apply during review gates before approval/merge.
---

# Code Review Rule

Review must be read-only and focused on correctness, risk, and maintainability.

## Review Areas

1. Correctness: logic, edge cases, null/empty handling, error paths
2. Architecture: pattern consistency, separation of concerns, dependency hygiene
3. Security: input validation, auth/authz, secret handling, injection risks
4. Performance: obvious bottlenecks, N+1 patterns, expensive loops/queries
5. Testing: coverage of happy path, failures, and critical edges
6. Readability: naming, structure, and clarity of intent

## Severity Policy

- `must_fix`: correctness/security/breaking issues; blocks merge in strict mode
- `should_fix`: significant quality or test gaps; expected before merge
- `nice_to_have`: non-blocking improvements

## Output Contract

Review output should include:

- files reviewed
- findings grouped by severity
- file pointers for each finding (`path:line`)
- concrete recommendation per finding
- residual risk statement when no blocker exists

## Guardrails

- Do not edit implementation during review mode.
- Do not downgrade blockers to stylistic notes.
- Prefer precise, actionable findings over generic advice.
