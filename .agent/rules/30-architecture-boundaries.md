---
name: architecture-boundaries
description: Application layer boundaries. Use when designing or refactoring app structure, understanding where code belongs.
---

# Architecture boundaries (big picture)
Mental model:
- Edges: app/views/ (HTML) and app/api/v1/ (JSON)
- Core: app/services/ and app/models/
- Infra: app/db.py, app/middleware/, app/config.py, app/catalog.py

Rule: IO at the edges; business logic in services/domain. Keep adapters isolated.

## Canonical app layout (example)
```
myapp/
  src/myapp/
    main.py
    api/
    domain/
    services/
    adapters/
    settings.py
  tests/
```
