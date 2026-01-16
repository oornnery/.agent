# Agent Rules & Guidelines

AI coding agent instructions for Python projects with FastAPI, Jx/JinjaX, HTMX, and modern tooling.

## Structure

```
.agent/
├── agents/              # Specialized subagents
│   ├── runner.md
│   ├── reviewer.md
│   ├── tester.md
│   └── researcher.md
├── rules/               # Instruction files with frontmatter
│   ├── 00-scope.md
│   ├── 01-second-order.md
│   ├── 10-project-modes.md
│   ├── 20-tooling-workflows.md
│   ├── 30-architecture-boundaries.md
│   ├── 40-html-first-jx-htmx.md
│   ├── ... (frontend, backend, realtime)
│   └── 90-agent-protocol.md
├── skills/              # Domain-specific capabilities
│   ├── pipeline/        # Feature → PR workflow
│   │   ├── SKILL.md
│   │   ├── steps/       # 10 pipeline steps
│   │   ├── stacks/      # Stack-specific guides
│   │   ├── templates/   # PR, commit templates
│   │   └── outputs/     # Schema definitions
│   ├── handoff/         # Context management
│   ├── explorer/        # Codebase analysis
│   ├── code-review/     # Review patterns
│   ├── git-workflow/    # Version control
│   └── test-runner/     # Test execution
├── prompts/             # System prompts
├── workflows/           # Orchestrated flows
└── scripts/             # Shell utilities
    └── agent.sh         # Setup & management
```

## Agent Skills Stack

All AI coding agents share the same skill definitions via symlinks.

| Agent        | Skill Path         |
| ------------ | ------------------ |
| OpenCode     | `.opencode/skill/` |
| Claude Code  | `.claude/skills/`  |
| Codex        | `.codex/skills/`   |
| Cursor       | `.cursor/skills/`  |
| Amp          | `.agents/skills/`  |
| Antigravity  | `.agent/skills/`   |
| Copilot      | `.copilot/skills/` |

### Setup

```bash
# Initialize all skills for an agent
./scripts/agent.sh init claude

# Initialize only specific skills
./scripts/agent.sh init claude --skills pipeline,handoff,test-runner

# Initialize with specific stack
./scripts/agent.sh init claude --skills pipeline --stack python

# Add a single skill
./scripts/agent.sh add skill pipeline

# List available skills
./scripts/agent.sh list skills

# Check status
./scripts/agent.sh status
```

## Skills

| Skill | Description |
|-------|-------------|
| `pipeline` | 10-step autonomous workflow (feature → PR) |
| `handoff` | Context management and session transfer |
| `explorer` | Read-only codebase analysis |
| `code-review` | Self-review patterns and checklists |
| `git-workflow` | Branch, commit, PR conventions |
| `test-runner` | Test execution and coverage |

### Pipeline Workflow

```bash
# Full autonomous mode
/pipeline --auto add user authentication

# Economy mode (minimal changes)
/pipeline --economy fix typo in README

# Interactive mode (checkpoints)
/pipeline --interactive refactor payment system
```

## Tech Stack

| Category        | Tools            |
| --------------- | ---------------- |
| Runtime         | Python >= 3.12   |
| Package Manager | uv (mandatory)   |
| Web Framework   | FastAPI          |
| Templating      | Jx / JinjaX      |
| Interactivity   | HTMX             |
| Styling         | Tailwind CSS     |
| Forms           | Formidable       |
| Database        | SQLModel (async) |
| Format/Lint     | ruff             |
| Typecheck       | ty               |
| Tests           | pytest           |
| Events          | FastStream       |

## Quick Start

```bash
# Clone and install
uv sync

# Run dev server
uv run uvicorn app.main:app --reload

# Quality checks (run before commits)
uv run ruff format .
uv run ruff check . --fix
uv run ty check src tests
uv run pytest -v
```

## References

- [Jx](https://github.com/jpsca/jx)
- [JinjaX](https://github.com/jpsca/jinjax)
- [HTMX](https://htmx.org)
- [Formidable](https://github.com/jpsca/formidable)
- [FastStream](https://faststream.airt.ai)
- [FastAPI](https://fastapi.tiangolo.com)
- [SQLModel](https://sqlmodel.tiangolo.com)
- [uv](https://github.com/astral-sh/uv)
- [ruff](https://github.com/astral-sh/ruff)

## License

MIT
