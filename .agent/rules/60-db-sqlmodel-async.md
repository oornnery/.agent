---
name: db-sqlmodel-async
description: Database patterns with SQLModel. Use when working with database models, queries, or migrations.
---

# Database (SQLModel async)
- Dev: SQLite async
- Prod: Postgres async
- Keep queries out of views when possible; prefer services/repo-like helpers.

Example (shape only):
```python
async with session_factory() as session:
    result = await session.exec(select(User).where(User.id == user_id))
    user = result.one()
```
