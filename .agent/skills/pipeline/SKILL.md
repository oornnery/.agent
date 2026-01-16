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

Execute steps sequentially:

| Step | File | Purpose |
|------|------|---------|
| 0 | `step-00-init.md` | Branch + workspace setup |
| 0b | `step-00b-economy.md` | Economy mode rules (optional) |
| 0b | `step-00b-interactive.md` | Interactive mode rules (optional) |
| 1 | `step-01-analyze.md` | Understand system + touch points |
| 2 | `step-02-plan.md` | Implementation plan + checkpoints |
| 3 | `step-03-execute.md` | Implement in small diffs |
| 4 | `step-04-validate.md` | Lint, typecheck, quick tests |
| 5 | `step-05-review.md` | Self-PR review |
| 6 | `step-06-resolve.md` | Fix issues from review |
| 7 | `step-07-tests.md` | Add/update tests |
| 8 | `step-08-run-tests.md` | Full test suite |
| 9 | `step-09-finish.md` | PR-ready output |

## Required Output: PIPELINE_STATE

After each step, produce a structured summary:

```json
{
  "goal": "one-line goal",
  "mode": "auto|economy|interactive",
  "branch": "feat/xxx",
  "scope": "affected areas",
  "files_touched": [],
  "commands_run": [],
  "test_status": "pending|pass|fail",
  "risks": [],
  "next_step": "step-XX"
}
```

See `outputs/schema.json` for full schema.

## Quality Bar to Finish

You can only finish if:
- ✅ Formatting + lint is clean
- ✅ Type-check is clean (if exists)
- ✅ Tests pass (existing + new)
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

## Subagents Available

| Agent | Purpose | Tools |
|-------|---------|-------|
| `runner` | Executes pipeline | Read, Edit, Bash, Grep |
| `reviewer` | Strict code review | Read, Grep (no edit) |
| `tester` | Test specialist | Read, Edit, Bash |
| `researcher` | Codebase analysis | Read, Grep, Glob |
