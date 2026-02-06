---
name: jx-sse
description: SSE patterns for JX + FastAPI + HTMX, including event contracts, streaming endpoints, reconnection, and real-time UI components.
---

# SSE for JX (FastAPI + HTMX)

Use this guide for real-time server-to-browser updates in JX apps.

## Scope

- SSE endpoint patterns in FastAPI
- HTMX SSE extension usage
- Event naming and payload contracts
- Keepalive/reconnect/disconnect handling
- JX component patterns (notifications, feed, progress, chat-like stream)

## Why SSE in JX

SSE is a strong default for HTML-first realtime:

- server -> client only (simple model)
- native browser support (`EventSource`)
- easy HTMX integration (`hx-ext="sse"`)
- no custom websocket protocol for basic push updates

## Client Setup

```html
<script src="https://unpkg.com/htmx.org@2.0.0"></script>
<script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
```

## SSE Message Contract

Server emits lines in this shape:

```text
event: notification
id: 42
retry: 3000
data: {"message":"Task complete","level":"success"}

```

Guidelines:

- Use named events (`notification`, `progress`, `new-post`) instead of only default `message`.
- Keep `data` as compact JSON string.
- Include `id` for reconnection support.
- Use periodic heartbeat comments (`: keepalive`).

## FastAPI Streaming Pattern (Canonical)

```python
import asyncio
import json
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse

app = FastAPI()

def sse(event: str, data: dict, event_id: str | None = None, retry_ms: int | None = None) -> str:
    lines: list[str] = []
    if event_id is not None:
        lines.append(f"id: {event_id}")
    if retry_ms is not None:
        lines.append(f"retry: {retry_ms}")
    lines.append(f"event: {event}")
    lines.append(f"data: {json.dumps(data, separators=(',', ':'))}")
    return "\n".join(lines) + "\n\n"

@app.get("/sse/notifications")
async def notifications_stream(request: Request):
    async def event_generator():
        seq = 0
        while True:
            if await request.is_disconnected():
                break

            # heartbeat every loop to avoid proxy idle timeout
            yield ": keepalive\n\n"

            seq += 1
            payload = {"message": f"Notification #{seq}", "level": "info"}
            yield sse(event="notification", data=payload, event_id=str(seq), retry_ms=3000)

            await asyncio.sleep(5)

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",  # nginx buffering off
        },
    )
```

## HTMX SSE Pattern

### Single event target

```jinja
<div hx-ext="sse" sse-connect="/sse/notifications">
  <div id="toast-stream" sse-swap="notification" hx-swap="beforeend"></div>
</div>
```

### Multiple event targets

```jinja
<div hx-ext="sse" sse-connect="/sse/dashboard">
  <div id="notifications" sse-swap="notification" hx-swap="afterbegin"></div>
  <div id="stats" sse-swap="stats"></div>
  <div id="progress" sse-swap="progress"></div>
</div>
```

## JX Component Examples

## 1) Live Notifications

```jinja
{#def endpoint="/sse/notifications" #}
<div
  hx-ext="sse"
  sse-connect="{{ endpoint }}"
  class="fixed top-4 right-4 z-50 w-96 space-y-2">
  <div id="notification-list" sse-swap="notification" hx-swap="afterbegin"></div>
</div>
```

Server sends pre-rendered HTML fragment in `data`:

```python
html = catalog.render("partials/NotificationItem", message="Build done", tone="success")
yield sse("notification", {"html": html})
```

If you send JSON, decode in Alpine/JS. If you send HTML, route to dedicated swap target.

## 2) Live Feed (prepend new cards)

```jinja
{#def endpoint="/sse/feed" #}
<div hx-ext="sse" sse-connect="{{ endpoint }}">
  <div id="feed" sse-swap="new-post" hx-swap="afterbegin" class="space-y-4"></div>
</div>
```

```python
@app.get("/sse/feed")
async def feed_stream(request: Request):
    async def gen():
        while True:
            if await request.is_disconnected():
                break
            post = await post_service.next_post()
            if post:
                card_html = catalog.render("partials/PostCard", post=post)
                yield sse("new-post", {"html": card_html}, event_id=str(post.id))
            else:
                yield ": keepalive\n\n"
            await asyncio.sleep(1)
    return StreamingResponse(gen(), media_type="text/event-stream")
```

## 3) Task Progress

```jinja
{#def task_id #}
<div hx-ext="sse" sse-connect="/sse/tasks/{{ task_id }}">
  <div sse-swap="progress" hx-swap="innerHTML"></div>
</div>
```

```python
@app.get("/sse/tasks/{task_id}")
async def task_progress(request: Request, task_id: str):
    async def gen():
        while True:
            if await request.is_disconnected():
                break
            state = await task_service.get_state(task_id)
            html = catalog.render("partials/TaskProgress", state=state)
            yield sse("progress", {"html": html}, event_id=str(state.step))
            if state.done:
                break
            await asyncio.sleep(1)
    return StreamingResponse(gen(), media_type="text/event-stream")
```

## 4) Chat-like Stream (receive only)

```jinja
{#def room_id #}
<div
  id="chat-stream"
  hx-ext="sse"
  sse-connect="/sse/rooms/{{ room_id }}"
  sse-swap="message"
  hx-swap="beforeend"
  class="space-y-2"></div>
```

POST messages in normal HTMX form endpoints; SSE is only for pushed updates.

## Typed Event Contracts (Pydantic)

Use typed payloads before serializing:

```python
from pydantic import BaseModel, ConfigDict

class NotificationEvent(BaseModel):
    model_config = ConfigDict(extra="forbid")
    message: str
    level: str = "info"

event = NotificationEvent(message="Deploy completed", level="success")
yield sse("notification", event.model_dump(mode="json"))
```

## Pub/Sub Broadcaster Pattern (Async)

```python
import asyncio
from collections.abc import AsyncGenerator

class Broadcaster:
    def __init__(self) -> None:
        self.subscribers: set[asyncio.Queue] = set()

    async def subscribe(self) -> asyncio.Queue:
        q: asyncio.Queue = asyncio.Queue(maxsize=100)
        self.subscribers.add(q)
        return q

    async def unsubscribe(self, q: asyncio.Queue) -> None:
        self.subscribers.discard(q)

    async def publish(self, event: str, data: dict) -> None:
        stale: list[asyncio.Queue] = []
        for q in self.subscribers:
            try:
                q.put_nowait((event, data))
            except asyncio.QueueFull:
                stale.append(q)
        for q in stale:
            self.subscribers.discard(q)
```

Use this for in-process fan-out. For multi-instance production, use Redis/NATS/Kafka broker-backed fan-out.

## Reconnection and Last Event ID

- Emit `id:` in every meaningful event.
- Browser sends `Last-Event-ID` on reconnect automatically.
- Optionally read `request.headers.get("last-event-id")` and replay missed events.

## Production Notes

- Disable proxy buffering (`X-Accel-Buffering: no`).
- Keep SSE uncompressed if proxy misbehaves with streaming gzip.
- Send heartbeat comments every 10-30s.
- Set sensible connection limits per user/session.
- Monitor open connections and stream lag.

## Guardrails

- Do not put business logic in streaming generator loops.
- Keep event names stable and documented.
- Use typed payload validation before emitting.
- Keep full-page routes separate from SSE stream routes.
- For bidirectional realtime needs, use WebSockets instead of forcing SSE.
