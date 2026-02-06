---
name: fastapi
description: FastAPI backend patterns for app factory, dependency injection, routing, schemas, security, and async data access.
---

# FastAPI Skill

Use this skill when building or refactoring FastAPI APIs and backend modules.

## Scope

- App bootstrap and lifespan
- Router and endpoint organization
- Pydantic models and validation
- Security controls (auth, headers, CSRF/XSS/SQLi defenses)
- Rate limiting
- Async service/repository patterns
- Error handling and response contracts
- SQLModel integration
- BFF aggregation patterns

## Loading Order

1. `.agent/skills/python/fastapi/core.md`
2. `.agent/skills/python/fastapi/api-endpoints.md`
3. `.agent/skills/python/fastapi/security.md`
4. `.agent/skills/python/fastapi/rate-limiting.md`
5. `.agent/skills/python/fastapi/sqlmodel.md`
6. `.agent/skills/python/fastapi/bff.md`
7. Optional events integration: `.agent/skills/python/faststream/SKILL.md`

## Guardrails

- Keep business logic out of routers
- Use typed request/response models
- Prefer async I/O boundaries
- Keep handlers thin and services explicit
- Keep security defaults strict; relax only with explicit rationale
