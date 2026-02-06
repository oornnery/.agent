---
name: fastapi
description: FastAPI backend standard for app setup, routing, dependencies, endpoint implementation, and endpoint-table documentation.
---

# FastAPI Skill

Canonical guide for building and documenting FastAPI APIs.

This file consolidates the previous `core.md` and `api-endpoints.md` content into one entrypoint to reduce duplication.

## Scope

- App factory and lifespan setup
- Router organization and versioning
- Dependency injection patterns
- Endpoint handler contracts
- Request/response schemas (Pydantic)
- Pydantic settings/config patterns (`pydantic-settings`)
- Event-driven messaging with FastStream
- Async/service/repository boundaries
- API endpoint documentation with Markdown tables
- Pointers to security, rate limiting, and SQLModel companions

## Companion Files

Load these when needed:

1. `.agent/skills/python/fastapi/security.md`
2. `.agent/skills/python/fastapi/rate-limiting.md`
3. `.agent/skills/python/fastapi/sqlmodel.md`
4. `.agent/skills/python/fastapi/pydantic.md`
5. `.agent/skills/python/fastapi/faststream.md`

## Implementation Standard

### 1) App Factory + Lifespan

- Initialize heavy resources in lifespan, not import time.
- Use `create_app()` as entrypoint.
- Include routers from one composition module.

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI

@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup resources
    yield
    # shutdown cleanup

def create_app() -> FastAPI:
    app = FastAPI(title="My API", version="v1", lifespan=lifespan)
    app.include_router(api_router)
    return app
```

### 2) Router Organization

- One router file per domain (`auth`, `posts`, `projects`, etc.).
- Version prefix at composition level (`/api/v1`).
- Tags by domain.

```python
api_router = APIRouter(prefix="/api/v1")
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(posts.router, prefix="/posts", tags=["posts"])
```

### 3) Endpoint Handler Contract

Every endpoint should define:

- `response_model`
- `status_code`
- `summary`
- explicit dependencies for auth/permissions when needed

Keep handlers thin:

- parse + validate input
- call service/use-case
- map expected errors (`HTTPException`)

### 4) Schema Contract (Pydantic)

- Use dedicated request/response schemas.
- Avoid returning ORM/entity objects directly.
- Use `model_config = ConfigDict(from_attributes=True)` in response models.
- For partial update, use optional fields and `exclude_unset=True`.

### 5) Pydantic + pydantic-settings Best Practices

Use this section as the canonical contract for validation and configuration models.
For a full deep-dive, load `.agent/skills/python/fastapi/pydantic.md`.

#### Install Notes

- `pydantic-settings` for `BaseSettings`.
- `pydantic[email]` (or `email-validator`) when using `EmailStr`.

#### Schema Model Rules

- Separate schemas by purpose: `Create`, `Update`, `Out`.
- Use strict model config by default:
  - `extra="forbid"`
  - `str_strip_whitespace=True`
  - `validate_assignment=True`
- Use `from_attributes=True` for response schemas that read ORM objects.
- Use `model_dump(exclude_unset=True)` for PATCH/partial updates.

```python
from pydantic import BaseModel, ConfigDict, EmailStr, SecretStr, field_validator

class UserCreate(BaseModel):
    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
        validate_assignment=True,
    )

    email: EmailStr
    username: str
    password: SecretStr

    @field_validator("username")
    @classmethod
    def username_min_len(cls, value: str) -> str:
        if len(value) < 3:
            raise ValueError("username must have at least 3 characters")
        return value
```

#### Settings Rules (`pydantic-settings`)

- Keep all runtime configuration in one `Settings` model.
- Use env prefix and `.env` file.
- Use typed fields (`PostgresDsn`, `AnyHttpUrl`, `EmailStr`, `SecretStr`).
- Never hardcode secrets in source.
- Load settings once with cache.

```python
from functools import lru_cache
from pydantic import AnyHttpUrl, EmailStr, PostgresDsn, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="APP_",
        extra="ignore",
    )

    app_name: str = "my-api"
    debug: bool = False
    api_base_url: AnyHttpUrl
    database_url: PostgresDsn
    support_email: EmailStr
    secret_key: SecretStr

@lru_cache
def get_settings() -> Settings:
    return Settings()
```

FastAPI dependency pattern:

```python
from fastapi import Depends

def get_config(settings: Settings = Depends(get_settings)) -> Settings:
    return settings
```

### 6) Async and Boundaries

- Use async I/O end-to-end for DB/network operations.
- Keep business logic in services, not routers.
- Keep repositories/data access isolated from API layer.

### 7) Error Contract

- `400/422` for invalid input
- `401/403` for auth/authz failures
- `404` for missing resources
- `409` for conflict/duplicate state
- Keep `detail` messages stable and actionable

## Endpoint Documentation Standard (Tables)

For each domain, maintain a Markdown table with this contract.

### Required Columns

- `Method`
- `Path`
- `Summary`
- `Auth`
- `Request`
- `Response`
- `Errors`

### Optional Columns

- `Rate Limit`
- `Idempotent`
- `Notes`

### Table Template

```md
## <Domain> API

| Method | Path | Summary | Auth | Request | Response | Errors |
|---|---|---|---|---|---|---|
| GET | /api/v1/<resource> | List resources | public | query: `ListQuery` | `200` `list[ResourceOut]` | `400` |
| GET | /api/v1/<resource>/{id} | Get resource by id | public | path: `id:int` | `200` `ResourceOut` | `404` |
| POST | /api/v1/<resource> | Create resource | required | body: `ResourceCreate` | `201` `ResourceOut` | `400`, `409`, `422` |
| PUT | /api/v1/<resource>/{id} | Update resource | required | body: `ResourceUpdate` | `200` `ResourceOut` | `404`, `422` |
| DELETE | /api/v1/<resource>/{id} | Delete resource | required | path: `id:int` | `204` none | `404` |
```

## Endpoint Template

```python
@router.get(
    "/{resource_id}",
    response_model=ResourceOut,
    status_code=200,
    summary="Get resource by id",
)
async def get_resource(resource_id: int) -> ResourceOut:
    resource = await service.get(resource_id)
    if resource is None:
        raise HTTPException(status_code=404, detail="Resource not found")
    return resource
```

## Guardrails

- Keep business logic out of routers.
- Keep endpoint tables synchronized with implementation changes.
- Prefer explicit contracts over implicit behavior.
- Keep local API behavior aligned with test coverage.
