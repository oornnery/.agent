---
name: architecture
description: Application architecture boundaries. Apply when designing or refactoring structure.
---

# Architecture Boundaries

## Layer Model
```
Edges    → app/views/ (HTML) + app/api/ (JSON)
Core     → app/services/ + app/models/
Infra    → app/db.py, app/config.py, adapters/
```

## Rule
- IO at edges only
- Business logic in services/domain
- Keep adapters isolated

## Canonical Layout
```
src/myapp/
├── main.py          # Entry point
├── api/             # JSON endpoints
├── views/           # HTML pages
├── services/        # Business logic
├── domain/          # Models, types
├── adapters/        # External services
└── settings.py      # Configuration
tests/
```
