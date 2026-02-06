---
name: jx
description: JX component architecture with HTMX, Alpine.js, SSE, forms, and HTML-first server-rendered workflows.
---

# JX Skill

Use this skill for component-driven HTML-first development with JX.

## Scope

- JX component conventions and imports
- Component catalog and composition
- HTMX interaction patterns
- Alpine.js local state patterns
- SSE real-time updates
- Form handling with Formidable
- Project scaffolding and page routing

## Loading Order

1. `.agent/skills/python/jx/core.md`
2. `.agent/skills/python/jx/components.md`
3. `.agent/skills/python/jx/htmx.md`
4. `.agent/skills/python/jx/alpine.md`
5. `.agent/skills/python/jx/sse.md`
6. `.agent/skills/python/jx/formidable.md`
7. `.agent/skills/python/jx/init-project.md`
8. `.agent/skills/python/jx/pages-routes.md`

## Guardrails

- Keep full-page and partial responses explicit
- Validate form input on server side
- Prefer reusable components over duplicated templates
- Keep JX as the only template component model for this skill
