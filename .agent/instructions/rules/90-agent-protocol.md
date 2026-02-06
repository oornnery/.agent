---
name: agent-protocol
description: Optional agent protocol rules. Apply when orchestrating multi-agent pipeline execution.
---

# Agent Protocol — Deterministic Pipeline Execution (Optional)

Use this rule only when running explicit multi-agent pipeline mode.

## PIPELINE_STATE Contract

In multi-agent pipeline mode, every step **MUST** end with a valid `PIPELINE_STATE` JSON block.

```json
{
  "current_step": "step-XX-name",
  "goal": "one-line goal",
  "mode": "auto|economy|interactive",
  "branch": "feat/xxx",
  "stack": {
    "detected": "python|node|go|rust",
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
- `stack` must be detected in the initial analysis step, never invented
- Statuses must be one of: `pending|pass|fail|skipped`

## Gate Steps (Mandatory)

These steps are **blocking gates** in multi-agent mode:

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

To prevent drift in multi-agent mode:

1. **Always emit PIPELINE_STATE** at step end
2. **Never skip gates** (steps 05 and 08)
3. **Store stack commands** once in initial analysis, reuse always
4. **Accumulate files_touched** across steps

## Recovery Protocol

If a step fails:

1. Log failure in `step_history`
2. Set `next_step` to retry or previous step
3. Do NOT proceed to next step
4. If 3 retries fail -> ask user
