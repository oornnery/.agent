---
name: agent-protocol
description: Agent protocol rules. Apply when orchestrating pipeline execution.
---

# Agent Protocol — Deterministic Pipeline Execution

## PIPELINE_STATE Contract

Every step **MUST** end with a valid `PIPELINE_STATE` JSON block.

```json
{
  "current_step": "step-XX-name",
  "goal": "one-line goal",
  "mode": "auto|economy|interactive",
  "branch": "feat/xxx",
  "stack": {
    "detected": "python-uv|node-pnpm|go|rust",
    "test_command": "...",
    "lint_command": "...",
    "format_command": "...",
    "typecheck_command": "..."
  },
  "next_step": "step-XX-name"
}
```

**Validation rules:**
- `current_step` and `next_step` are REQUIRED
- `stack` must be detected by step-01, never invented
- Statuses must be one of: `pending|pass|fail|skipped`

## Gate Steps (Mandatory)

These steps are **blocking gates** — cannot proceed if they fail:

| Step | Gate Type | Agent | Blocking Condition |
|------|-----------|-------|-------------------|
| 05-review | Code Review | `reviewer` | Any `must_fix` issue |
| 08-run-tests | CI Parity | `tester` | Any test/lint/type failure |

## Agent Isolation (RLM Recursion)

Each agent has **isolated context** and **cannot** do other agents' jobs:

| Agent | Can | Cannot |
|-------|-----|--------|
| `runner` | Edit, Execute, Orchestrate | Review, Test |
| `reviewer` | Read, Analyze, Report | Edit files |
| `tester` | Read, Write tests, Run tests | Business logic |
| `researcher` | Read, Search, Map | Edit anything |

## State Preservation

To prevent drift:
1. **Always emit PIPELINE_STATE** at step end
2. **Never skip gates** (steps 05 and 08)
3. **Store stack commands** once in step-01, reuse always
4. **Accumulate files_touched** across steps

## Recovery Protocol

If a step fails:
1. Log failure in `step_history`
2. Set `next_step` to retry or previous step
3. Do NOT proceed to next step
4. If 3 retries fail → ask user
