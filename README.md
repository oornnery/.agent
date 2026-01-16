# Agent Rules & Skills

AI coding agent instructions for Python projects with FastAPI, Jx/JinjaX, HTMX, and modern tooling.

## Structure

```
.agent/
├── agents/              # Specialized personas
│   ├── runner.md        # Executes /pipeline
│   ├── reviewer.md      # Read-only review
│   ├── tester.md        # Test specialist
│   └── researcher.md    # Codebase analysis
│
├── rules/               # Short principles (< 30 lines)
│   ├── 00-core.md       # Safety + scope
│   ├── 01-python.md     # Python style
│   ├── 02-architecture.md
│   └── 03-tooling.md    # uv, ruff, ty, pytest
│
├── skills/
│   ├── pipeline/        # Feature → PR workflow
│   │   ├── SKILL.md
│   │   ├── steps/       # 10 pipeline steps
│   │   └── outputs/     # State schema
│   │
│   ├── frameworks/      # Framework-specific guides
│   │   ├── jx-jinjax.md
│   │   ├── faststream.md
│   │   ├── formidable.md
│   │   ├── sqlmodel.md
│   │   └── sse.md
│   │
│   ├── patterns/        # Design patterns
│   │   ├── design-system.md
│   │   ├── animations.md
│   │   ├── ui-components.md
│   │   ├── api-endpoints.md
│   │   ├── security.md
│   │   ├── rate-limiting.md
│   │   ├── bff-pattern.md
│   │   └── pages-routes.md
│   │
│   ├── code-review/     # Self-review checklists
│   ├── test-runner/     # Test execution
│   ├── git-workflow/    # Git conventions
│   ├── handoff/         # Context transfer
│   └── explorer/        # Codebase analysis
│
├── stacks/              # Tech-specific configs
│   ├── python-uv.md
│   ├── node-pnpm.md
│   ├── go.md
│   └── rust.md
│
├── templates/           # PR, commit, changelog
├── prompts/             # System prompts
├── workflows/           # Orchestrated flows
└── scripts/
    └── agent.sh
```

## Skills

| Skill | Description |
|-------|-------------|
| `/pipeline` | 10-step feature → PR workflow |
| `/code-review` | Self-review checklists |
| `/test-runner` | Test execution & debugging |
| `/git-workflow` | Branch, commit, PR conventions |
| `/handoff` | Context management |
| `/explorer` | Codebase analysis |

## Frameworks

| Guide | Description |
|-------|-------------|
| `jx-jinjax` | Jx + JinjaX components |
| `sse` | Server-Sent Events + HTMX |
| `formidable` | Form handling |
| `sqlmodel` | Async database patterns |
| `faststream` | Event streaming |

## Quick Start

```bash
uv sync
uv run task check  # format + lint + typecheck + test
uv run task dev    # start dev server
```

## Setup

```bash
# Initialize skills for an agent
uv run scripts/agent.py init claude

# Add specific skill
uv run scripts/agent.py add skill pipeline

# List available
uv run scripts/agent.py list

# Check status
uv run scripts/agent.py status
```

> **Note**: Use `uv run --no-cache` if you see hardlink errors.

