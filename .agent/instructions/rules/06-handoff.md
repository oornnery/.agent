---
name: handoff
description: Session state transfer and continuation protocol. Apply when ending a session, switching major tasks, or transferring work between agents.
---

# Handoff Rule

Use this rule to preserve execution state and make continuation deterministic.

## When To Apply

- Context is large or nearing limits
- Switching major task scope
- Ending current work session
- Passing work to another agent/person

## Required Handoff Contents

Every handoff artifact must include:

1. Current goal
2. Completed / in-progress / blocked items
3. Files touched with rationale
4. Key decisions and assumptions
5. Next steps with exact resume commands

## Canonical Workflow

Use `.agent/workflows/handoff.md` for template and execution sequence.

## Multi-Agent References

- Pipeline contract: `.agent/instructions/rules/90-agent-protocol.md`
- Context strategy (`MAP → DRILL → EXEC`): `.agent/instructions/rules/11-rlm-context.md`
- Rule loading matrix: `.agent/instructions/rules/README.md`
- Agent boundaries: `.agent/agents/README.md`

## Guardrails

- Keep summaries factual and concise.
- Preserve concrete file pointers (`path:line`) for unresolved items.
- Do not claim checks passed unless they were run.
- Do not drop known blockers; record them explicitly.
