---
name: project-modes
description: Project structure patterns. Use when creating new projects or understanding folder organization.
---

# Project modes (choose one; keep boundaries)
This repo supports multiple shapes. Do NOT mix boundaries:

- App (FastAPI service): routers at the edge, business logic in services/domain.
- Package (library): stable public API in public.py; internals in _internal/.
- Scripts (ops/data jobs): reusable code under src/<proj>/shared/.
- Tools (CLI): Typer CLI in cli.py; commands in commands/.

Use the canonical folder templates from AGENTS.md as the source of truth.
