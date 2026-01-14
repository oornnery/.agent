# Agent Rules & Guidelines

AI coding agent instructions for Python projects with FastAPI, Jx/JinjaX, HTMX, and modern tooling.

## Structure

```bash
.agent/
├── rules/           # Instruction files with frontmatter
│   ├── 00-scope.md
│   ├── 10-project-modes.md
│   ├── 20-tooling-workflows.md
│   ├── 30-architecture-boundaries.md
│   ├── 40-html-first-jx-htmx.md
│   ├── 41-design-system.md
│   ├── 42-animations.md
│   ├── 43-ui-components.md
│   ├── 44-pages-routes.md
│   ├── 45-api-endpoints.md
│   ├── 46-security.md
│   ├── 47-rate-limiting.md
│   ├── 48-sse-htmx.md
│   ├── 49-bff-pattern.md
│   ├── 50-forms-formidable.md
│   ├── 55-faststream.md
│   ├── 60-db-sqlmodel-async.md
│   ├── 70-python-style.md
│   ├── 80-testing.md
│   └── 90-agent-protocol.md
└── prompts/
    └── generate-agent-instructions.prompt.md
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

## Rules Index

### Core (always apply)

- **00-scope** — Atomic changes, KISS, no hallucinating paths
- **90-agent-protocol** — Safety rules for AI agents

### Project Structure

- **10-project-modes** — App / Package / Scripts / Tools patterns
- **30-architecture-boundaries** — Edges / Core / Infra layers

### Tooling

- **20-tooling-workflows** — uv, ruff, ty, pytest commands
- **80-testing** — pytest guidelines

### Web Stack (HTML-first)

- **40-html-first-jx-htmx** — Jx components + HTMX patterns
- **41-design-system** — Colors, typography, breakpoints
- **42-animations** — Keyframes, transitions, loading states
- **43-ui-components** — Button, Card, Input, Tag, Icon, Navbar
- **44-pages-routes** — Page structure + FastAPI routing
- **45-api-endpoints** — REST API patterns
- **50-forms-formidable** — Formidable + HTMX forms

### Security & Performance

- **46-security** — OWASP headers, JWT, HTMX validation
- **47-rate-limiting** — slowapi limits

### Real-time & Events

- **48-sse-htmx** — Server-Sent Events + HTMX
- **49-bff-pattern** — Backend for Frontend
- **55-faststream** — Event-driven microservices

### Data

- **60-db-sqlmodel-async** — SQLModel async patterns
- **70-python-style** — Coding conventions

## Rule File Format

Each rule file uses YAML frontmatter:

```yaml
---
name: rule-name
description: When to use this rule...
---

# Rule Title

Content with examples...
```

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
