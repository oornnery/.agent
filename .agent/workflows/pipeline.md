---
description: Run the autonomous development pipeline from feature to PR
---

# Pipeline Workflow

Run the 10-step autonomous development pipeline.

## Usage

```bash
# Full autonomous mode
/pipeline --auto [feature description]

# Economy mode (quick, minimal)
/pipeline --auto --economy [small fix]

# Interactive mode (checkpoints)
/pipeline --interactive [risky change]

# Full workflow with review and tests
/pipeline --auto --review --tests [feature]
```

## Steps

// turbo-all

1. **Init**: Create branch, confirm clean state
2. **Analyze**: Understand codebase, find touch points
3. **Plan**: Create implementation plan
4. **Execute**: Implement in small diffs
5. **Validate**: Run format, lint, typecheck
6. **Review**: Self-review for issues
7. **Resolve**: Fix review issues
8. **Tests**: Add/update tests
9. **Run Tests**: Verify full suite
10. **Finish**: Create PR

## Modes

| Mode | Description |
|------|-------------|
| `--auto` | Fully autonomous, ask only when blocked |
| `--economy` | Minimal changes, skip optional steps |
| `--interactive` | Ask for approval at checkpoints |
| `--review` | Include thorough code review |
| `--tests` | Generate tests for new code |
| `--pr` | Create GitHub PR (requires gh cli) |

## Examples

```bash
# Add a feature
/pipeline --auto add JWT authentication to API

# Quick fix
/pipeline --auto --economy fix typo in config loader

# Safe refactor
/pipeline --interactive refactor billing pipeline

# Full workflow
/pipeline --auto --review --tests add user registration
```
