# Pipeline — Feature → PR Autonomous Workflow

A powerful skill that runs 10 autonomous steps from feature request to merge-ready PR.

## Quick Start

```bash
# Full autonomous mode
/pipeline --auto add user authentication

# Economy mode (minimal changes)
/pipeline --economy fix typo in README

# Interactive mode (checkpoints)
/pipeline --interactive refactor payment system
```

## Pipeline Steps

| # | Step | Description |
|---|------|-------------|
| 0 | Init | Branch creation + workspace setup |
| 1 | Analyze | Understand codebase + find touch points |
| 2 | Plan | Create implementation plan |
| 3 | Execute | Implement changes in small diffs |
| 4 | Validate | Run lint, format, typecheck |
| 5 | Review | Self-review for issues |
| 6 | Resolve | Fix review issues |
| 7 | Tests | Add/update tests |
| 8 | Run Tests | Execute full test suite |
| 9 | Finish | Create PR with full description |

## Modes

- **AUTO**: Fully autonomous, asks only when blocked
- **ECONOMY**: Minimal token usage, smallest viable change
- **INTERACTIVE**: Asks for approval at key checkpoints

## Stack Support

Automatically detects and adapts to:
- Python (uv + ruff + ty + pytest)
- Node.js (pnpm)
- Go
- Rust

## Directory Structure

```
pipeline/
├── SKILL.md          # Main orchestrator
├── README.md         # This file
├── steps/            # Individual step instructions
├── stacks/           # Stack-specific guides
├── templates/        # PR, commit, changelog templates
└── outputs/          # Schema definitions
```

## Subagents

| Agent | Role |
|-------|------|
| runner | Executes the pipeline |
| reviewer | Strict code review |
| tester | Test specialist |
| researcher | Codebase analysis |
