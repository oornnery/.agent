---
name: pipeline
description: End-to-end autonomous pipeline from feature request to merged-ready PR. Use when the user says "build/implement/add feature", "fix bug", "create PR", "ship this", or wants a full code change workflow (branch -> analyze -> plan -> execute -> validate -> review -> fix -> tests -> PR).
---

# Pipeline — Feature → PR Autonomous Workflow

You are running a **10-step autonomous engineering pipeline** that turns a feature request into a merge-ready PR.

## Operating Principles (non-negotiable)

- **Small diffs, frequent checkpoints** (avoid "big bang" refactors).
- **Plan before you write.**
- **Always validate** locally (lint, type-check, tests) before finishing.
- **Prefer boring solutions** over cleverness.
- **Never silently skip failing checks**. If something fails: diagnose → fix → re-run.
- **Maintain repo conventions** (tooling, naming, architecture, patterns).

## Modes

| Mode | Description |
|------|-------------|
| `AUTO` | Fully autonomous; ask only when blocked |
| `ECONOMY` | Minimize context/tool calls; smallest viable change |
| `INTERACTIVE` | Micro-questions at key checkpoints |

If the user did not specify mode, default to **AUTO**.

## Stack Detection

Before planning/executing, infer the stack by scanning:
- lockfiles / package managers (`uv.lock`, `pnpm-lock.yaml`, `go.sum`, `Cargo.lock`)
- tool configs (`pyproject.toml`, `package.json`, `go.mod`, `Cargo.toml`)
- CI pipeline files (`.github/workflows/`)
- existing commands in README/Makefile

Then follow the matching stack guide in `stacks/`.

## Step Execution Order

Execute steps sequentially. **Gate steps are blocking.**

| Step | File | Purpose | Gate? |
|------|------|---------|-------|
| 0 | `step-00-init.md` | Branch + workspace setup | |
| 0b | `step-00b-economy.md` | Economy mode rules (optional) | |
| 0b | `step-00b-interactive.md` | Interactive mode rules (optional) | |
| 1 | `step-01-analyze.md` | Understand system + touch points | |
| 2 | `step-02-plan.md` | Implementation plan + checkpoints | |
| 3 | `step-03-execute.md` | Implement in small diffs | |
| 4 | `step-04-validate.md` | Lint, typecheck, quick tests | |
| 5 | `step-05-review.md` | Self-PR review | 🚧 **GATE** |
| 6 | `step-06-resolve.md` | Fix issues from review | |
| 7 | `step-07-tests.md` | Add/update tests | |
| 8 | `step-08-run-tests.md` | Full test suite | 🚧 **GATE** |
| 9 | `step-09-finish.md` | PR-ready output | |

## Gate Steps (Blocking)

These steps require agent delegation and cannot be skipped:

### Step 05 — Review Gate
- **Delegate to**: `reviewer` agent (READ-ONLY)
- **Blocking condition**: Any `must_fix` issue
- **Required output**: `review_passed: true` in PIPELINE_STATE

### Step 08 — Validation Gate  
- **Delegate to**: `tester` agent
- **Blocking condition**: Any test/lint/type failure
- **Required output**: `validation_passed: true` in PIPELINE_STATE

## Required Output: PIPELINE_STATE

**Every step MUST end with a valid PIPELINE_STATE.**

```json
{
  "current_step": "step-XX-name",
  "goal": "one-line goal",
  "mode": "auto|economy|interactive",
  "branch": "feat/xxx",
  "stack": {
    "detected": "python-uv",
    "test_command": "uv run pytest -v",
    "lint_command": "uv run ruff check .",
    "format_command": "uv run ruff format .",
    "typecheck_command": "uv run ty check"
  },
  "files_touched": [],
  "test_status": "pending|pass|fail",
  "review_passed": true,
  "validation_passed": true,
  "next_step": "step-XX"
}
```

See `outputs/schema.json` for full schema.

## Quality Bar to Finish

You can only finish if:
- ✅ Formatting + lint is clean
- ✅ Type-check is clean (if exists)
- ✅ Tests pass (existing + new)
- ✅ Review gate passed (`review_passed: true`)
- ✅ Validation gate passed (`validation_passed: true`)
- ✅ PR description complete (what/why/how/tested/risk)
- ✅ No obvious TODOs left behind

## Usage Examples

```bash
# Full auto (feature → PR)
/pipeline --auto add JWT auth to API

# Quick economy mode
/pipeline --economy fix typo in config loader

# Interactive for risky changes
/pipeline --interactive refactor billing pipeline safely
```

## Subagents (Agent Isolation)

| Agent | Purpose | Tools | Isolation |
|-------|---------|-------|-----------|
| `runner` | Orchestrates pipeline | Read, Edit, Bash, Grep | Main driver |
| `reviewer` | Code review gate | Read, Grep | **READ-ONLY** |
| `tester` | Test/validation gate | Read, Edit, Bash | Tests only |
| `researcher` | Codebase analysis | Read, Grep, Glob | **READ-ONLY** |

**Isolation Rules:**
- Runner **cannot** do code review → must delegate to `reviewer`
- Runner **should** delegate tests → to `tester`
- Reviewer **cannot** edit files
- Researcher **cannot** edit files
