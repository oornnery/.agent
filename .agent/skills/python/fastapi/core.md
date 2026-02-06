---
name: fastapi
description: >
  FastAPI best practices and Python backend patterns. Use this skill when building API endpoints,
  structuring projects, configuring dependency injection, handling forms with Pydantic, managing
  database operations (SQLModel, SQLAlchemy), configuring environment settings (pydantic-settings),
  validating email (pydantic[email]), handling async patterns, or structuring error handling.
  Triggers include FastAPI, Pydantic, SQLModel, SQLAlchemy, app factory, dependency injection,
  router organization, pydantic-settings, BaseSettings, EmailStr, or CRUD patterns.
---

# FastAPI Best Practices

Comprehensive reference for building production-ready FastAPI applications. Covers app architecture, dependency injection, Pydantic validation, SQLModel/SQLAlchemy, pydantic-settings, and async patterns.

---

## 1. App Factory Pattern

```python
from fastapi import FastAPI
from fastapi.middleware.gzip import GZipMiddleware
from contextlib import asynccontextmanager
from typing import AsyncGenerator

@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator:
    # Startup
    app.state.db_engine = create_async_engine(settings.database_url)
    app.state.http_client = httpx.AsyncClient(timeout=30.0)
    yield
    # Shutdown
    await app.state.db_engine.dispose()
    await app.state.http_client.aclose()

def create_app(config: Settings | None = None) -> FastAPI:
    if config is None:
        config = Settings()

    app = FastAPI(title=config.app_name, version=config.version, lifespan=lifespan)
    app.add_middleware(GZipMiddleware, minimum_size=1000)
    app.include_router(api_router, prefix="/api")
    app.include_router(web_router)
    app.mount("/static", StaticFiles(directory="static"), name="static")
    app.state.config = config
    return app
```

**Pitfalls**: Don't initialize heavy resources at import time. Don't use deprecated `@app.on_event("startup")`. Always clean up in shutdown.

---

## 2. Dependency Injection

```python
from typing import Annotated
from fastapi import Depends

# DB session
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        yield session

# Auth chain
async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> User:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if user is None:
        raise credentials_exception
    return user

# Permission guard
async def require_admin(
    current_user: Annotated[User, Depends(get_current_user)]
) -> User:
    if not current_user.is_admin:
        raise HTTPException(status_code=403, detail="Admin access required")
    return current_user

# Router-level deps
router = APIRouter(prefix="/api/v1", dependencies=[Depends(verify_api_key)])
```

**Pitfalls**: Always use `Annotated` (FastAPI 0.100+). Don't use sync deps for I/O. Dependencies are cached per-request.

---

## 3. Router Organization

```bash
app/
├── main.py              # App factory
├── core/
│   ├── config.py        # Settings (pydantic-settings)
│   ├── security.py      # Auth utilities
│   └── dependencies.py  # Shared deps
├── api/
│   ├── router.py        # Aggregator
│   └── v1/
│       ├── auth.py
│       ├── users.py
│       └── posts.py
├── models/              # SQLModel table models
├── schemas/             # Pydantic request/response
├── services/            # Business logic
├── repositories/        # Data access
└── web/                 # HTML/template routes
```

**Router aggregation:**

```python
api_router = APIRouter(prefix="/api/v1")
api_router.include_router(users.router)
api_router.include_router(posts.router)
api_router.include_router(auth.router)
```

---

## 4. Async Patterns

```python
# Concurrent queries
users_task = db.execute(select(User).limit(10))
posts_task = db.execute(select(Post).limit(10))
users_result, posts_result = await asyncio.gather(users_task, posts_task)

# Connection pool
engine = create_async_engine(
    DATABASE_URL,
    pool_size=10,
    max_overflow=10,
    pool_pre_ping=True,
    pool_recycle=3600
)

async_session_maker = async_sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False  # CRITICAL for async
)
```

---

## 5. Error Handling

```python
# Domain exceptions
class UserNotFoundError(HTTPException):
    def __init__(self, user_id: int):
        super().__init__(status_code=404, detail=f"User {user_id} not found")

# Global handler
@app.exception_handler(RequestValidationError)
async def validation_handler(request: Request, exc: RequestValidationError):
    if request.headers.get("HX-Request"):
        # Return HTML for HTMX
        errors = {e["loc"][-1]: e["msg"] for e in exc.errors()}
        return catalog.render("@ui/partials/FormErrors.jinja", errors=errors)
    return JSONResponse(status_code=422, content={"detail": exc.errors()})
```

---

## 6. Pydantic Models

### BaseModel Best Practices

```python
from pydantic import BaseModel, Field, field_validator, model_validator, ConfigDict

class UserCreate(BaseModel):
    email: str
    username: str = Field(..., min_length=3, max_length=50, pattern=r"^[a-zA-Z0-9_]+$")
    password: str = Field(..., min_length=8)
    password_confirm: str

    model_config = ConfigDict(
        str_strip_whitespace=True,
        validate_assignment=True,
        from_attributes=True,       # ORM mode
    )

    @field_validator("email")
    @classmethod
    def normalize_email(cls, v: str) -> str:
        if "@" not in v:
            raise ValueError("Invalid email")
        return v.lower()

    @field_validator("password")
    @classmethod
    def strong_password(cls, v: str) -> str:
        if not any(c.isupper() for c in v):
            raise ValueError("Must contain uppercase")
        if not any(c.isdigit() for c in v):
            raise ValueError("Must contain digit")
        return v

    @model_validator(mode="after")
    def passwords_match(self) -> "UserCreate":
        if self.password != self.password_confirm:
            raise ValueError("Passwords do not match")
        return self
```

### Request/Response Separation

```python
# Create (input)
class UserCreate(BaseModel):
    email: EmailStr
    username: str
    password: str

# Update (partial input)
class UserUpdate(BaseModel):
    email: EmailStr | None = None
    username: str | None = None
    full_name: str | None = None

# Response (output)
class UserResponse(BaseModel):
    id: int
    email: str
    username: str
    is_active: bool
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

# Usage
@app.post("/users", response_model=UserResponse)
async def create_user(user: UserCreate, db: Annotated[AsyncSession, Depends(get_db)]):
    ...

@app.patch("/users/{id}", response_model=UserResponse)
async def update_user(id: int, user: UserUpdate, db: ...):
    update_data = user.model_dump(exclude_unset=True)  # Only changed fields
    ...
```

### Custom Types

```python
from pydantic import Field
from typing import Annotated

PositiveInt = Annotated[int, Field(gt=0)]
NonEmptyStr = Annotated[str, Field(min_length=1, strip_whitespace=True)]
Price = Annotated[float, Field(gt=0, decimal_places=2)]
```

---

## 7. Pydantic for Forms

### Form Data Validation

```python
from fastapi import Form, File, UploadFile

class ContactForm(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    email: str = Field(..., pattern=r"^[\w\.-]+@[\w\.-]+\.\w+$")
    message: str = Field(..., min_length=10, max_length=5000)

@app.post("/contact")
async def contact(form_data: Annotated[ContactForm, Form()]):
    # form_data is validated Pydantic model
    ...
```

### HTMX Validation Errors

```python
@app.exception_handler(RequestValidationError)
async def htmx_validation_handler(request: Request, exc: RequestValidationError):
    if request.headers.get("HX-Request"):
        errors = {e["loc"][-1]: e["msg"] for e in exc.errors()}
        html = "<ul>" + "".join(f"<li>{f}: {m}</li>" for f, m in errors.items()) + "</ul>"
        return HTMLResponse(content=html, status_code=422)
    return JSONResponse(status_code=422, content={"detail": exc.errors()})
```

**Pitfalls**: Always use `Form()` dep for form data. Return HTML errors for HTMX requests, not JSON.

---

## 8. pydantic-settings

```python
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field, SecretStr, PostgresDsn

class Settings(BaseSettings):
    app_name: str = "My App"
    debug: bool = False
    environment: Literal["development", "staging", "production"] = "production"

    # Secrets (hidden in logs/repr)
    secret_key: SecretStr = Field(..., min_length=32)
    database_url: PostgresDsn

    # JWT
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    # CORS
    cors_origins: list[str] = ["http://localhost:3000"]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_prefix="APP_",
        case_sensitive=False,
        extra="ignore"
    )

# Nested settings
class DatabaseSettings(BaseSettings):
    host: str = "localhost"
    port: int = 5432
    user: str
    password: SecretStr
    database: str
    model_config = SettingsConfigDict(env_prefix="DB_")

    @property
    def url(self) -> str:
        return f"postgresql+asyncpg://{self.user}:{self.password.get_secret_value()}@{self.host}:{self.port}/{self.database}"

# Dependency
def get_settings() -> Settings:
    return Settings()
```

**Pitfalls**: Always use `SecretStr` for sensitive data. Never commit `.env`. Set `env_file_encoding="utf-8"`.

---

## 9. pydantic[email]

```python
# pip install "pydantic[email]"
from pydantic import EmailStr

class UserCreate(BaseModel):
    email: EmailStr  # Validates email format automatically

    @field_validator("email")
    @classmethod
    def normalize(cls, v: EmailStr) -> str:
        return v.lower()

# Business email validation
class BusinessContact(BaseModel):
    email: EmailStr

    @field_validator("email")
    @classmethod
    def no_free_providers(cls, v: str) -> str:
        domain = v.split("@")[1].lower()
        free = ["gmail.com", "yahoo.com", "hotmail.com", "outlook.com"]
        if domain in free:
            raise ValueError("Business email required")
        return v
```

---

## 10. SQLModel

### Model Definition

```python
from sqlmodel import SQLModel, Field, Relationship
from datetime import datetime

class User(SQLModel, table=True):
    __tablename__ = "users"
    id: int | None = Field(default=None, primary_key=True)
    email: str = Field(unique=True, index=True, max_length=255)
    username: str = Field(unique=True, index=True, max_length=50)
    hashed_password: str = Field(max_length=255)
    is_active: bool = Field(default=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    posts: list["Post"] = Relationship(back_populates="author")

class Post(SQLModel, table=True):
    __tablename__ = "posts"
    id: int | None = Field(default=None, primary_key=True)
    title: str = Field(max_length=200)
    content: str
    author_id: int = Field(foreign_key="users.id")
    author: User | None = Relationship(back_populates="posts")
```

### CRUD Patterns

```python
# Create
async def create_user(db: AsyncSession, data: UserCreate) -> User:
    user = User(**data.model_dump())
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

# Read
async def get_user(db: AsyncSession, user_id: int) -> User | None:
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()

# Update (partial)
async def update_user(db: AsyncSession, user_id: int, data: UserUpdate) -> User | None:
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        return None
    for field, value in data.model_dump(exclude_unset=True).items():
        setattr(user, field, value)
    await db.commit()
    await db.refresh(user)
    return user

# Delete
async def delete_user(db: AsyncSession, user_id: int) -> bool:
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        return False
    await db.delete(user)
    await db.commit()
    return True
```

### Eager Loading (Prevent N+1)

```python
from sqlalchemy.orm import selectinload

result = await db.execute(
    select(User)
    .where(User.id == user_id)
    .options(selectinload(User.posts))
)
```

---

## 11. SQLAlchemy Async

### Engine Setup

```python
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

engine = create_async_engine(
    "postgresql+asyncpg://user:pass@localhost/db",
    pool_size=10,
    max_overflow=10,
    pool_pre_ping=True,
    pool_recycle=3600,
    echo=False
)

async_session_maker = async_sessionmaker(
    engine, class_=AsyncSession,
    expire_on_commit=False,  # CRITICAL for async
    autoflush=False
)
```

### Session Dependency

```python
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
```

---

## Quick Reference

```txt
FACTORY:    create_app() with lifespan context manager, middleware, routers
DI:         Annotated[Type, Depends(dep)] chains, router-level deps
ASYNC:      asyncio.gather for concurrent I/O, expire_on_commit=False
PYDANTIC:   field_validator, model_validator, model_dump(exclude_unset=True)
FORMS:      Annotated[Model, Form()], File/UploadFile, HTMX error responses
SETTINGS:   BaseSettings, .env, SecretStr, env_prefix, nested with env_nested_delimiter
EMAIL:      EmailStr from pydantic[email], normalize to lowercase
SQLMODEL:   table=True models, Relationship, Field(foreign_key=...), selectinload
SQLALCHEMY: create_async_engine, async_sessionmaker, pool_pre_ping=True
ERRORS:     Domain HTTPException subclasses, HTMX-aware global handlers
```
