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
│   ├── 03-tooling.md    # uv, ruff, ty, pytest
│   ├── 04-safe-commands.md  # Command whitelist
│   └── 11-rlm-context.md    # RLM context management
│
├── skills/
│   ├── pipeline/        # Feature → PR workflow
│   │   ├── SKILL.md
│   │   ├── steps/       # 10 pipeline steps
│   │   └── outputs/     # State schema
│   │
│   ├── context-map/     # Fast repo indexing (RLM)
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

## Supported Environments

| Agent | Skills Path | Instructions File | Description |
|-------|-------------|-------------------|-------------|
| `cursor` | `.cursor/skills` | `.cursorrules` | Cursor AI editor |
| `claude` | `.claude/skills` | `CLAUDE.md` | Claude Code (Anthropic) |
| `codex` | `.codex/skills` | `AGENTS.md` | OpenAI Codex CLI |
| `copilot` | `.copilot/skills` | `.github/copilot-instructions.md` | GitHub Copilot |
| `antigravity` | `.agent/skills` | `GEMINI.md` | Gemini CLI (Google) |
| `amp` | `.agents/skills` | `AGENTS.md` | Amp (Sourcegraph) |
| `opencode` | `.opencode/skill` | — | OpenCode AI editor |

## RLM Context Management

Based on [Recursive Language Models (MIT CSAIL)](https://arxiv.org/abs/2512.24601), the agent uses efficient context strategies:

### MAP → DRILL → EXEC Pattern

1. **MAP**: Build lightweight index (glob/find/grep)
2. **DRILL**: Open only relevant regions (80-200 lines max)
3. **EXEC**: Implement with minimal context

### Key Rules

- `11-rlm-context.md` — Context as environment, slice policy
- `context-map` skill — Fast repo indexing

### Benefits

- ✅ Less context waste (reads only what's needed)
- ✅ Less model drift (focused context)
- ✅ More determinism (clear patterns)
- ✅ Lower cost (fewer tokens)

## Setup

```bash
# Initialize for specific agent
uv run agent.py init cursor
uv run agent.py init claude

# Initialize all agents at once
uv run agent.py init all

# Add specific skill
uv run agent.py add skill pipeline

# Show environment config
uv run agent.py env

# List available skills/stacks/agents
uv run agent.py list

# Check status
uv run agent.py status
```

> **Note**: Use `uv run --no-cache` if you see hardlink errors.

