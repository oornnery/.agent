---
name: faststream
description: Event-driven service patterns using FastStream with Kafka/RabbitMQ/NATS/Redis and FastAPI integration.
---

# FastStream Skill

Use this skill for async pub/sub, consumers, publishers, and broker lifecycle integration.

## Scope

- Broker configuration
- Subscriber and publisher patterns
- Event model contracts
- FastAPI + FastStream lifecycle integration

## Guardrails

- Keep event schemas explicit with typed models
- Avoid business logic directly in transport handlers
- Handle broker startup/shutdown deterministically

## Guide

# FastStream (Event-Driven Microservices)

FastStream for building event-driven services with Kafka, RabbitMQ, NATS, Redis.

**Docs**: https://faststream.airt.ai

---

## Installation

```bash
uv add faststream[kafka]   # or [rabbitmq], [nats], [redis]
```

---

## Basic Consumer

```python
from faststream import FastStream
from faststream.kafka import KafkaBroker

broker = KafkaBroker("localhost:9092")
app = FastStream(broker)

@broker.subscriber("user.created")
async def handle_user_created(data: dict):
    user_id = data["user_id"]
    await send_welcome_email(user_id)
    await create_default_settings(user_id)
```

---

## Publisher

```python
from faststream.kafka import KafkaBroker

broker = KafkaBroker("localhost:9092")

@broker.publisher("notifications")
async def publish_notification(user_id: int, message: str):
    return {"user_id": user_id, "message": message, "type": "info"}

# Usage
await publish_notification(123, "Welcome!")
```

---

## Pydantic Models

```python
from pydantic import BaseModel

class UserCreated(BaseModel):
    user_id: int
    email: str
    name: str

class NotificationEvent(BaseModel):
    user_id: int
    message: str
    type: str = "info"

@broker.subscriber("user.created")
async def handle_user(event: UserCreated):
    await send_welcome_email(event.email, event.name)
```

---

## Integration with FastAPI

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
from faststream.kafka import KafkaBroker

broker = KafkaBroker("localhost:9092")

@asynccontextmanager
async def lifespan(app: FastAPI):
    await broker.start()
    yield
    await broker.close()

app = FastAPI(lifespan=lifespan)

# Publish from API endpoint
@app.post("/users")
async def create_user(data: UserCreate):
    user = await user_service.create(data)
    await broker.publish(
        {"user_id": user.id, "email": user.email},
        topic="user.created"
    )
    return user
```

---

## Project Structure

```
app/
  main.py           # FastAPI app
  broker.py         # FastStream broker instance
  events/
    __init__.py
    user.py         # User event handlers
    notifications.py
  publishers/
    __init__.py
    user.py         # User event publishers
```

### broker.py

```python
from faststream.kafka import KafkaBroker
from app.config import settings

broker = KafkaBroker(settings.KAFKA_URL)
```

### events/user.py

```python
from app.broker import broker
from app.models.events import UserCreated

@broker.subscriber("user.created")
async def on_user_created(event: UserCreated):
    await analytics_service.track_signup(event.user_id)
    await email_service.send_welcome(event.email)
```
