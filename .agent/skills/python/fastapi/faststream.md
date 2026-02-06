---
name: faststream
description: FastStream patterns for event-driven workflows in FastAPI projects (brokers, event contracts, publishers, subscribers, reliability).
---

# FastStream (Inside FastAPI)

Use this guide when your FastAPI service needs async pub/sub and broker-driven workflows.

## Scope

- Broker setup and lifecycle
- Event schema contracts with Pydantic
- Publisher and subscriber patterns
- Reliability patterns (idempotency, retries, DLQ, observability)
- FastAPI + FastStream integration

## When To Use

- Cross-service async integration
- Background processing decoupled from HTTP latency
- Domain events (`user.created`, `order.paid`, etc.)
- Fan-out notifications

## Install

```bash
# Choose one broker backend
uv add faststream[kafka]
uv add faststream[rabbitmq]
uv add faststream[nats]
uv add faststream[redis]
```

## Event Contract Pattern

Use explicit versioned events with metadata:

```python
from datetime import datetime, timezone
from pydantic import BaseModel, ConfigDict, EmailStr, Field

class EventMeta(BaseModel):
    event_id: str
    event_type: str
    event_version: str = "v1"
    occurred_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    source: str = "api"
    correlation_id: str | None = None
    idempotency_key: str | None = None

class UserCreatedEvent(BaseModel):
    model_config = ConfigDict(extra="forbid")

    meta: EventMeta
    user_id: int
    email: EmailStr
    username: str
```

## Broker Setup

```python
# app/messaging/broker.py
from faststream.kafka import KafkaBroker
from app.core.config import get_settings

settings = get_settings()
broker = KafkaBroker(settings.kafka_url)
```

## Publisher Pattern

Keep publish logic in dedicated publisher modules, not in routers.

```python
# app/messaging/publishers/user_events.py
from app.messaging.broker import broker
from app.messaging.schemas import UserCreatedEvent

async def publish_user_created(event: UserCreatedEvent) -> None:
    await broker.publish(event.model_dump(mode="json"), topic="user.created")
```

## Subscriber Pattern

Keep subscriber handlers thin and delegate to services.

```python
# app/messaging/subscribers/user_events.py
from faststream import Logger
from app.messaging.broker import broker
from app.messaging.schemas import UserCreatedEvent
from app.services.onboarding import onboarding_service

@broker.subscriber("user.created")
async def on_user_created(payload: UserCreatedEvent, logger: Logger) -> None:
    logger.info("received user.created user_id=%s", payload.user_id)
    await onboarding_service.handle_user_created(payload)
```

## FastAPI Integration (Lifespan)

Start/stop broker with app lifecycle.

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.messaging.broker import broker

@asynccontextmanager
async def lifespan(app: FastAPI):
    await broker.start()
    try:
        yield
    finally:
        await broker.close()
```

## HTTP -> Event Flow Example

```python
from fastapi import APIRouter, Depends, status
from app.schemas.user import UserCreate, UserOut
from app.services.user_service import user_service
from app.messaging.schemas import EventMeta, UserCreatedEvent
from app.messaging.publishers.user_events import publish_user_created
from app.core.id import new_id

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=UserOut, status_code=status.HTTP_201_CREATED)
async def create_user(payload: UserCreate) -> UserOut:
    user = await user_service.create(payload)

    event = UserCreatedEvent(
        meta=EventMeta(
            event_id=new_id(),
            event_type="user.created",
            correlation_id=new_id(),
            idempotency_key=f"user-created:{user.id}",
        ),
        user_id=user.id,
        email=user.email,
        username=user.username,
    )
    await publish_user_created(event)
    return UserOut.model_validate(user)
```

## Reliability Patterns

### Idempotency

- Include `idempotency_key` in event metadata.
- Subscriber side should store processed keys to avoid duplicate side effects.

### Retry + Failure Handling

- Retry transient failures (network, broker hiccups).
- Do not retry validation/business rule failures indefinitely.
- Route poisoned messages to dead-letter topics/queues.

### Outbox Pattern (Recommended for Critical Events)

- Persist domain change + outbox record in one DB transaction.
- Background dispatcher publishes outbox records to broker.
- Mark outbox record as sent after successful publish.

## Observability

- Log `event_type`, `event_id`, `correlation_id`.
- Emit success/failure counters per topic.
- Track processing latency and retry count.
- Keep structured logs for replay/debug.

## Guardrails

- Never put business logic directly in transport handlers.
- Keep event schemas backward-compatible per `event_version`.
- Validate payloads strictly with Pydantic models.
- Prefer one canonical publisher/subscriber module per event domain.
