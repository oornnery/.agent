---
name: sse-htmx
description: Server-Sent Events for real-time updates with HTMX. Use when implementing notifications, progress bars, or live feeds.
---

# SSE (Server-Sent Events) with HTMX

Server-Sent Events for real-time updates: notifications, progress, feeds, logs.

## HTMX SSE Extension

Load the SSE extension:
```html
<script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
```

---

## FastAPI SSE Endpoint

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import asyncio

@app.get("/sse/notifications")
async def sse_notifications():
    async def event_generator():
        while True:
            notifications = await get_new_notifications()
            if notifications:
                for n in notifications:
                    yield f"event: notification\ndata: {n.to_html()}\n\n"
            await asyncio.sleep(2)

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={"Cache-Control": "no-cache", "Connection": "keep-alive"}
    )
```

---

## Jx Component with SSE

```jinja
{#def #}
<div
  hx-ext="sse"
  sse-connect="/sse/notifications"
  sse-swap="notification"
>
  <div id="notifications" sse-swap="notification" hx-swap="beforeend">
    <!-- Notifications appear here -->
  </div>
</div>
```

---

## Progress Bar Example

### FastAPI endpoint

```python
@app.get("/sse/progress/{task_id}")
async def sse_progress(task_id: str):
    async def progress_generator():
        for i in range(0, 101, 10):
            yield f"event: progress\ndata: {i}\n\n"
            await asyncio.sleep(0.5)
        yield f"event: complete\ndata: done\n\n"

    return StreamingResponse(progress_generator(), media_type="text/event-stream")
```

### Jx component

```jinja
{#def task_id #}
<div hx-ext="sse" sse-connect="/sse/progress/{{ task_id }}">
  <div class="w-full bg-[var(--surface-2)] rounded-full h-4">
    <div
      id="progress-bar"
      class="bg-[var(--accent)] h-4 rounded-full transition-all"
      style="width: 0%"
      sse-swap="progress"
      hx-swap="none"
      hx-on:sse-progress="this.style.width = event.detail.data + '%'"
    ></div>
  </div>
  <p id="status" sse-swap="complete" hx-swap="innerHTML">Processing...</p>
</div>
```

---

## Live Feed Example

```python
@app.get("/sse/feed")
async def sse_feed():
    async def feed_generator():
        async for post in watch_new_posts():
            html = catalog.render("blog/PostCard", post=post)
            escaped = html.replace("\n", "").replace("\r", "")
            yield f"event: new-post\ndata: {escaped}\n\n"

    return StreamingResponse(feed_generator(), media_type="text/event-stream")
```

```jinja
<div hx-ext="sse" sse-connect="/sse/feed">
  <div id="feed" sse-swap="new-post" hx-swap="afterbegin" class="space-y-4">
    <!-- New posts prepended here -->
  </div>
</div>
```
