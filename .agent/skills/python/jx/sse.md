
# Server-Sent Events (SSE) Implementation for JX

## Overview

SSE enables real-time server-to-client communication:

- Unidirectional (server → client)
- Uses standard HTTP
- Auto-reconnects on disconnect
- Simpler than WebSockets

## Client Setup

### HTMX SSE Extension

```html
<script src="https://unpkg.com/htmx.org@2.0.0"></script>
<script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
```

### Basic Connection

```jinja
{# Connect and swap messages #}
<div 
  hx-ext="sse"
  sse-connect="/events"
  sse-swap="message">
  {# Content replaced on each message #}
</div>

{# Append messages #}
<div 
  hx-ext="sse"
  sse-connect="/events"
  sse-swap="message:beforeend">
  {# Messages appended here #}
</div>

{# Multiple event types #}
<div hx-ext="sse" sse-connect="/events">
  <div sse-swap="notification">Notifications here</div>
  <div sse-swap="update">Updates here</div>
</div>
```

### JavaScript EventSource

```javascript
const eventSource = new EventSource('/events');

eventSource.onmessage = (event) => {
  console.log('Message:', event.data);
};

eventSource.addEventListener('notification', (event) => {
  console.log('Notification:', event.data);
});

eventSource.onerror = (error) => {
  console.error('SSE Error:', error);
};

// Close connection
eventSource.close();
```

## Flask Implementation

### Basic Endpoint

```python
from flask import Flask, Response, stream_with_context
import json
import time

app = Flask(__name__)

@app.route('/events')
def events():
    def generate():
        while True:
            data = {'time': time.time(), 'message': 'Hello!'}
            yield f"data: {json.dumps(data)}\n\n"
            time.sleep(1)
    
    return Response(
        stream_with_context(generate()),
        mimetype='text/event-stream',
        headers={
            'Cache-Control': 'no-cache',
            'Connection': 'keep-alive',
            'X-Accel-Buffering': 'no'  # Disable nginx buffering
        }
    )
```

### Named Events

```python
@app.route('/events')
def events():
    def generate():
        while True:
            # Notification event
            yield f"event: notification\ndata: New message!\n\n"
            
            # Update event with JSON
            data = json.dumps({'count': get_count()})
            yield f"event: update\ndata: {data}\n\n"
            
            time.sleep(2)
    
    return Response(
        stream_with_context(generate()),
        mimetype='text/event-stream'
    )
```

### Pub/Sub Pattern

```python
from flask import Flask, Response
from queue import Queue
import threading
import json

app = Flask(__name__)

class MessageBroker:
    def __init__(self):
        self.subscribers = []
        self.lock = threading.Lock()
    
    def subscribe(self):
        q = Queue()
        with self.lock:
            self.subscribers.append(q)
        return q
    
    def unsubscribe(self, q):
        with self.lock:
            if q in self.subscribers:
                self.subscribers.remove(q)
    
    def publish(self, event_type, data):
        message = {'type': event_type, 'data': data}
        with self.lock:
            for q in self.subscribers:
                q.put(message)

broker = MessageBroker()

@app.route('/events')
def events():
    def generate():
        queue = broker.subscribe()
        try:
            while True:
                message = queue.get(timeout=30)
                data = json.dumps(message['data'])
                yield f"event: {message['type']}\ndata: {data}\n\n"
        except:
            # Timeout - send keepalive
            yield f": keepalive\n\n"
        finally:
            broker.unsubscribe(queue)
    
    return Response(
        stream_with_context(generate()),
        mimetype='text/event-stream'
    )

@app.route('/notify', methods=['POST'])
def notify():
    data = request.json
    broker.publish('notification', data)
    return {'status': 'sent'}
```

## FastAPI Implementation

### Basic Endpoint

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import asyncio
import json

app = FastAPI()

@app.get("/events")
async def events():
    async def generate():
        while True:
            data = json.dumps({'time': time.time()})
            yield f"data: {data}\n\n"
            await asyncio.sleep(1)
    
    return StreamingResponse(
        generate(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        }
    )
```

### With sse-starlette

```bash
pip install sse-starlette
```

```python
from fastapi import FastAPI
from sse_starlette.sse import EventSourceResponse
import asyncio

app = FastAPI()

@app.get("/events")
async def events():
    async def event_generator():
        while True:
            yield {
                "event": "notification",
                "data": json.dumps({"message": "Hello"})
            }
            await asyncio.sleep(1)
    
    return EventSourceResponse(event_generator())
```

### Async Pub/Sub

```python
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse
import asyncio
import json
from typing import Set

app = FastAPI()

class Broadcaster:
    def __init__(self):
        self.subscribers: Set[asyncio.Queue] = set()
    
    async def subscribe(self) -> asyncio.Queue:
        queue = asyncio.Queue()
        self.subscribers.add(queue)
        return queue
    
    async def unsubscribe(self, queue: asyncio.Queue):
        self.subscribers.discard(queue)
    
    async def broadcast(self, event_type: str, data: dict):
        for queue in self.subscribers:
            await queue.put({"event": event_type, "data": data})

broadcaster = Broadcaster()

@app.get("/events")
async def events(request: Request):
    queue = await broadcaster.subscribe()
    
    async def generate():
        try:
            while True:
                if await request.is_disconnected():
                    break
                try:
                    message = await asyncio.wait_for(queue.get(), timeout=30)
                    data = json.dumps(message["data"])
                    yield f"event: {message['event']}\ndata: {data}\n\n"
                except asyncio.TimeoutError:
                    yield f": keepalive\n\n"
        finally:
            await broadcaster.unsubscribe(queue)
    
    return StreamingResponse(
        generate(),
        media_type="text/event-stream"
    )

@app.post("/notify")
async def notify(data: dict):
    await broadcaster.broadcast("notification", data)
    return {"status": "sent"}
```

## Django Implementation

### StreamingHttpResponse

```python
from django.http import StreamingHttpResponse
import json
import time

def events(request):
    def event_stream():
        while True:
            data = json.dumps({'time': time.time()})
            yield f"data: {data}\n\n"
            time.sleep(1)
    
    response = StreamingHttpResponse(
        event_stream(),
        content_type='text/event-stream'
    )
    response['Cache-Control'] = 'no-cache'
    return response
```

### Django Channels (Recommended)

```python
# consumers.py
from channels.generic.http import AsyncHttpConsumer
import asyncio
import json

class SSEConsumer(AsyncHttpConsumer):
    async def handle(self, body):
        await self.send_headers(headers=[
            (b"Cache-Control", b"no-cache"),
            (b"Content-Type", b"text/event-stream"),
        ])
        
        while True:
            data = await self.get_data()
            message = f"data: {json.dumps(data)}\n\n"
            await self.send_body(message.encode(), more_body=True)
            await asyncio.sleep(1)
    
    async def get_data(self):
        return {'time': time.time()}

# routing.py
from django.urls import re_path
from . import consumers

urlpatterns = [
    re_path(r'^events/$', consumers.SSEConsumer.as_asgi()),
]
```

## JX Component Patterns

### Live Notifications

```jinja
{# components/features/live-notifications.jinja #}
{#import "../ui/alert.jinja" as Alert #}
{#def endpoint="/notifications" #}

<div 
  x-data="{ 
    notifications: [],
    add(data) {
      const n = JSON.parse(data)
      n.id = Date.now()
      this.notifications.unshift(n)
      if (this.notifications.length > 10) {
        this.notifications.pop()
      }
    },
    remove(id) {
      this.notifications = this.notifications.filter(n => n.id !== id)
    }
  }"
  hx-ext="sse"
  sse-connect="{{ endpoint }}"
  @htmx:sse-message="add($event.detail.data)"
  class="fixed top-4 right-4 w-80 space-y-2 z-50">
  
  <template x-for="n in notifications" :key="n.id">
    <div 
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0 translate-x-8"
      x-transition:enter-end="opacity-100 translate-x-0"
      :class="{
        'bg-blue-100 border-blue-500': n.type === 'info',
        'bg-green-100 border-green-500': n.type === 'success',
        'bg-red-100 border-red-500': n.type === 'error'
      }"
      class="p-4 rounded-lg border-l-4 shadow-md bg-white">
      <div class="flex justify-between">
        <p x-text="n.message"></p>
        <button @click="remove(n.id)" class="ml-2 text-gray-400">&times;</button>
      </div>
    </div>
  </template>
</div>
```

### Real-time Counter

```jinja
{# components/features/live-counter.jinja #}
{#def endpoint, label #}

<div 
  hx-ext="sse"
  sse-connect="{{ endpoint }}"
  class="flex items-center gap-2">
  <span class="text-sm text-gray-500">{{ label }}:</span>
  <span 
    sse-swap="count"
    class="font-bold text-lg"
    x-data
    x-effect="$el.classList.add('text-green-500'); setTimeout(() => $el.classList.remove('text-green-500'), 300)">
    0
  </span>
</div>
```

### Chat Component

```jinja
{# components/features/chat.jinja #}
{#def room_id #}

<div class="flex flex-col h-96 border rounded-lg bg-white">
  {# Messages #}
  <div 
    id="messages-{{ room_id }}"
    hx-ext="sse"
    sse-connect="/chat/{{ room_id }}/events"
    sse-swap="message:beforeend"
    class="flex-1 overflow-y-auto p-4 space-y-3">
  </div>
  
  {# Input #}
  <form 
    hx-post="/chat/{{ room_id }}/send"
    hx-swap="none"
    hx-on::after-request="this.reset()"
    class="p-4 border-t flex gap-2">
    <input 
      type="text"
      name="message"
      placeholder="Type a message..."
      autocomplete="off"
      class="flex-1 px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500">
    <button 
      type="submit"
      class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">
      Send
    </button>
  </form>
</div>
```

### Progress Tracker

```jinja
{# components/features/progress.jinja #}
{#def task_id #}

<div 
  hx-ext="sse"
  sse-connect="/tasks/{{ task_id }}/progress"
  class="space-y-2">
  <div class="flex justify-between text-sm">
    <span sse-swap="status">Starting...</span>
    <span sse-swap="percent">0%</span>
  </div>
  <div class="h-2 bg-gray-200 rounded-full overflow-hidden">
    <div 
      id="progress-bar"
      sse-swap="bar:outerHTML"
      class="h-full bg-blue-500 transition-all duration-300"
      style="width: 0%">
    </div>
  </div>
</div>
```

## SSE Message Format

```
event: eventName      # Optional event type
id: 123               # Optional message ID
retry: 1000           # Reconnection time in ms
data: message content # Required - can be multi-line

```

Multi-line data:

```
event: update
data: {"line1": "value",
data: "line2": "value2"}

```

## Best Practices

1. **Keep-alive**: Send periodic comments (`: keepalive\n\n`) to prevent timeout
2. **Message IDs**: Use `id:` field for reconnection support
3. **Buffering**: Disable proxy buffering (nginx: `X-Accel-Buffering: no`)
4. **Compression**: Disable gzip for SSE responses
5. **Connection limits**: Implement per-user connection limits
6. **Graceful shutdown**: Handle client disconnection properly
7. **Heartbeat**: Include periodic events to detect dead connections

---

## HTMX SSE Quick Patterns (Merged)


# SSE (Server-Sent Events) with HTMX

Server-Sent Events for real-time updates: notifications, progress, feeds, logs.

## HTMX SSE Extension

Load the SSE extension:
```html
<script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
```


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
