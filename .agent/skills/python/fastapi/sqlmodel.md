---
name: sqlmodel
description: SQLModel + FastAPI async patterns for models, schemas, queries, transactions, and repository/service boundaries.
---

# SQLModel (FastAPI Async)

Use this guide when building database-backed FastAPI features with SQLModel.

## Scope

- SQLModel table modeling
- Pydantic/SQLModel schema patterns
- Async engine/session setup
- CRUD/query patterns
- Relationships and loading strategies
- Transaction and error-handling patterns

## Core Principles

- Keep table models focused on persistence concerns.
- Keep request/response contracts explicit (separate input/output schemas).
- Keep DB access in repository-like modules; keep routers thin.
- Use async session end-to-end for DB I/O.
- Prefer explicit query shape and pagination defaults.

## Recommended Structure

```text
app/
  db/
    models/
      user.py
      post.py
    session.py
  schemas/
    user.py
    post.py
  repositories/
    user_repo.py
    post_repo.py
  services/
    user_service.py
```

## Model Patterns

### Table Models

```python
from datetime import datetime, timezone
from typing import Optional
from sqlmodel import Field, SQLModel

class User(SQLModel, table=True):
    __tablename__ = "users"

    id: int | None = Field(default=None, primary_key=True)
    email: str = Field(index=True, unique=True, max_length=255)
    username: str = Field(index=True, unique=True, max_length=50)
    is_active: bool = Field(default=True)
    created_at: datetime = Field(
        default_factory=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
```

### Input/Output Schemas

Keep create/update/read contracts separate from table models.

```python
from sqlmodel import SQLModel

class UserCreate(SQLModel):
    email: str
    username: str

class UserUpdate(SQLModel):
    email: str | None = None
    username: str | None = None
    is_active: bool | None = None

class UserOut(SQLModel):
    id: int
    email: str
    username: str
    is_active: bool
```

## Async Engine and Session

```python
from collections.abc import AsyncGenerator
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

DATABASE_URL = "postgresql+asyncpg://user:pass@localhost:5432/app"

engine = create_async_engine(
    DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

async_session_maker = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        yield session
```

## CRUD Patterns

### Create

```python
from sqlmodel import SQLModel

async def create_user(session: AsyncSession, data: UserCreate) -> User:
    user = User.model_validate(data)
    session.add(user)
    await session.commit()
    await session.refresh(user)
    return user
```

### Read One

```python
from sqlmodel import select

async def get_user_by_id(session: AsyncSession, user_id: int) -> User | None:
    result = await session.exec(select(User).where(User.id == user_id))
    return result.one_or_none()
```

### List with Pagination

```python
from sqlmodel import select

async def list_users(session: AsyncSession, offset: int = 0, limit: int = 20) -> list[User]:
    statement = select(User).offset(offset).limit(limit).order_by(User.id.desc())
    result = await session.exec(statement)
    return result.all()
```

### Partial Update

```python
async def update_user(session: AsyncSession, user: User, data: UserUpdate) -> User:
    patch = data.model_dump(exclude_unset=True)
    for field, value in patch.items():
        setattr(user, field, value)
    session.add(user)
    await session.commit()
    await session.refresh(user)
    return user
```

### Delete

```python
async def delete_user(session: AsyncSession, user: User) -> None:
    await session.delete(user)
    await session.commit()
```

## Relationships

```python
from typing import Optional
from sqlmodel import Field, Relationship, SQLModel

class Post(SQLModel, table=True):
    __tablename__ = "posts"

    id: int | None = Field(default=None, primary_key=True)
    title: str
    author_id: int = Field(foreign_key="users.id", index=True)
    author: Optional["User"] = Relationship(back_populates="posts")

class User(SQLModel, table=True):
    __tablename__ = "users"

    id: int | None = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True)
    posts: list[Post] = Relationship(back_populates="author")
```

Load relationships explicitly when needed:

```python
from sqlalchemy.orm import selectinload
from sqlmodel import select

async def get_user_with_posts(session: AsyncSession, user_id: int) -> User | None:
    stmt = (
        select(User)
        .where(User.id == user_id)
        .options(selectinload(User.posts))
    )
    result = await session.exec(stmt)
    return result.one_or_none()
```

## FastAPI Endpoint Integration

```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=UserOut, status_code=status.HTTP_201_CREATED)
async def create_user_endpoint(
    payload: UserCreate,
    session: AsyncSession = Depends(get_session),
) -> UserOut:
    user = await create_user(session, payload)
    return UserOut.model_validate(user)

@router.get("/{user_id}", response_model=UserOut)
async def get_user_endpoint(
    user_id: int,
    session: AsyncSession = Depends(get_session),
) -> UserOut:
    user = await get_user_by_id(session, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return UserOut.model_validate(user)
```

## Transactions

Use explicit transactions for multi-step writes:

```python
async def create_user_and_post(
    session: AsyncSession,
    user_data: UserCreate,
    post_title: str,
) -> tuple[User, Post]:
    async with session.begin():
        user = User.model_validate(user_data)
        session.add(user)
        await session.flush()  # get user.id before commit

        post = Post(title=post_title, author_id=user.id)
        session.add(post)

    await session.refresh(user)
    await session.refresh(post)
    return user, post
```

## Error Handling Notes

- Map unique violations to `409 Conflict`.
- Map missing resources to `404 Not Found`.
- Never expose raw DB errors directly to API clients.
- Keep domain/service errors explicit and stable.

## Practical Guardrails

- Prefer PostgreSQL in production (`asyncpg`); use SQLite async only for local/dev.
- Keep migrations managed (for example with Alembic), never manual schema drift.
- Add indexes for common lookup fields (`email`, `slug`, foreign keys).
- Use sane pagination defaults (`limit <= 100`).
- Keep response schemas minimal and avoid leaking internal columns.
