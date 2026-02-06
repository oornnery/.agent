---
name: pydantic
description: Comprehensive Pydantic and pydantic-settings guide for FastAPI (models, validation, serialization, settings, env, secrets, and advanced patterns).
---

# Pydantic + pydantic-settings (FastAPI)

Use this document as the deep reference for data contracts and configuration models.

## Scope

- Pydantic v2 model design
- Validation and normalization
- Serialization and response shaping
- Advanced types and unions
- Partial update patterns
- `pydantic-settings` for environment configuration
- FastAPI integration and testing patterns

## Install

```bash
uv add pydantic pydantic-settings
uv add "pydantic[email]"      # EmailStr support (email-validator)
```

## Base Model Conventions

Use explicit config defaults to avoid ambiguous behavior.

```python
from pydantic import BaseModel, ConfigDict

class APIModel(BaseModel):
    model_config = ConfigDict(
        extra="forbid",            # reject unknown fields
        str_strip_whitespace=True, # normalize input strings
        validate_assignment=True,  # enforce validation on updates
    )
```

Derive app schemas from this base model.

## Schema Segmentation

Keep schemas separate by use-case:

- `Create`: input for POST
- `Update`: optional fields for PATCH/PUT
- `Out`: response model
- `Internal`: domain-only/internal transfers

```python
from pydantic import ConfigDict, EmailStr, SecretStr

class UserCreate(APIModel):
    email: EmailStr
    username: str
    password: SecretStr

class UserUpdate(APIModel):
    email: EmailStr | None = None
    username: str | None = None
    is_active: bool | None = None

class UserOut(APIModel):
    id: int
    email: EmailStr
    username: str
    is_active: bool
    model_config = ConfigDict(from_attributes=True)
```

## Field Constraints and Typed Aliases

Prefer `Annotated` aliases for reusable constraints.

```python
from typing import Annotated
from pydantic import Field

Slug = Annotated[str, Field(pattern=r"^[a-z0-9-]+$", min_length=3, max_length=120)]
PageSize = Annotated[int, Field(ge=1, le=100)]
```

## Validators

### `field_validator`

Use for single-field normalization and constraints.

```python
from pydantic import field_validator

class UserCreate(APIModel):
    email: str
    username: str

    @field_validator("email")
    @classmethod
    def normalize_email(cls, value: str) -> str:
        return value.lower().strip()
```

### `model_validator`

Use for cross-field rules.

```python
from pydantic import model_validator, SecretStr

class RegisterInput(APIModel):
    password: SecretStr
    password_confirm: SecretStr

    @model_validator(mode="after")
    def passwords_match(self) -> "RegisterInput":
        if self.password.get_secret_value() != self.password_confirm.get_secret_value():
            raise ValueError("passwords do not match")
        return self
```

## Serialization and Response Shaping

### `field_serializer`

```python
from datetime import datetime
from pydantic import field_serializer

class AuditOut(APIModel):
    created_at: datetime

    @field_serializer("created_at")
    def serialize_dt(self, value: datetime) -> str:
        return value.isoformat()
```

### `computed_field`

```python
from pydantic import computed_field

class UserOut(APIModel):
    first_name: str
    last_name: str

    @computed_field
    @property
    def full_name(self) -> str:
        return f"{self.first_name} {self.last_name}"
```

## Unions and Polymorphism

Use discriminated unions for predictable parsing.

```python
from typing import Literal, Union
from pydantic import Field

class CardPayment(APIModel):
    method: Literal["card"]
    card_last4: str

class PixPayment(APIModel):
    method: Literal["pix"]
    pix_key: str

PaymentInput = Union[CardPayment, PixPayment]

class CheckoutInput(APIModel):
    payment: PaymentInput = Field(discriminator="method")
```

## Generic Response Envelopes

```python
from typing import Generic, TypeVar
from pydantic import BaseModel

T = TypeVar("T")

class Envelope(BaseModel, Generic[T]):
    data: T
    trace_id: str
```

Use `Envelope[UserOut]` as `response_model` in FastAPI when you want standardized responses.

## Partial Update Pattern

For PATCH endpoints, only apply provided fields:

```python
patch = user_update.model_dump(exclude_unset=True)
for key, value in patch.items():
    setattr(entity, key, value)
```

Never use full `model_dump()` for partial updates unless you intentionally want defaults applied.

## pydantic-settings

### Canonical Settings Model

```python
from functools import lru_cache
from pydantic import AnyHttpUrl, PostgresDsn, RedisDsn, SecretStr, EmailStr
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_prefix="APP_",
        extra="ignore",
        case_sensitive=False,
    )

    app_name: str = "my-api"
    environment: str = "dev"
    debug: bool = False

    api_base_url: AnyHttpUrl
    database_url: PostgresDsn
    redis_url: RedisDsn

    support_email: EmailStr
    secret_key: SecretStr

@lru_cache
def get_settings() -> Settings:
    return Settings()
```

### Nested Configuration

```python
from pydantic import BaseModel

class JWTSettings(BaseModel):
    algorithm: str = "HS256"
    access_ttl_minutes: int = 15

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_nested_delimiter="__")
    jwt: JWTSettings = JWTSettings()
```

Environment example:

```bash
APP_JWT__ALGORITHM=HS512
APP_JWT__ACCESS_TTL_MINUTES=30
```

### FastAPI Dependency

```python
from fastapi import Depends

def get_config(settings: Settings = Depends(get_settings)) -> Settings:
    return settings
```

## FastAPI Integration Patterns

### Request/Response contracts

```python
@router.post("/users", response_model=UserOut, status_code=201)
async def create_user(payload: UserCreate) -> UserOut:
    user = await service.create(payload)
    return UserOut.model_validate(user)
```

### Validation errors

Keep default FastAPI validation format unless you explicitly standardize a custom error schema.

## Security-Related Types

- `EmailStr`: validated email input
- `SecretStr`: avoid accidental plaintext logging
- `AnyHttpUrl`: URL validation
- `PostgresDsn` / `RedisDsn` / `AmqpDsn`: typed connection strings
- `IPvAnyAddress`: IP validation when needed

## Testing Patterns

### Override settings in tests

```python
def get_test_settings() -> Settings:
    return Settings(environment="test", debug=False)

app.dependency_overrides[get_settings] = get_test_settings
```

### Model-level tests

Test validators directly for critical schemas (auth, money, event contracts).

## Common Pitfalls

- Mixing persistence entities with API response schemas.
- Using `extra="allow"` in public input models.
- Forgetting `exclude_unset=True` in partial updates.
- Returning secrets by mistake in response models.
- Reading settings repeatedly without caching.

## Guardrails

- Keep schemas explicit and minimal.
- Keep config typed and centralized.
- Favor deterministic validation over permissive parsing.
- Prefer backward-compatible schema evolution for public APIs/events.
