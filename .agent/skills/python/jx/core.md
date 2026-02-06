
# JX - Next Generation Python Server-Side Components

JX is the evolution of JX, providing Jinja-powered components with explicit imports, type-safe arguments, and encapsulated assets. It integrates seamlessly with HTMX, Alpine.js, SSE, and TailwindCSS.

## Installation

```bash
pip install jx
```

## Core Concepts

### Catalog Setup

```python
from jx import Catalog

# Create catalog with components folder path
catalog = Catalog("components/")

# Render a component
def myview():
    return catalog.render("dashboard.jinja")
```

### Component Structure

Components are `.jinja` files with explicit imports at the top.

```jinja
{# components/card.jinja #}
{#def title, url #}

<div class="bg-white shadow rounded border p-4">
  <h2 class="m-0 text-gray-800">{{ title }}</h2>
  <p>{{ content }}</p>
  <a href="{{ url_for(url) }}" class="text-teal-600">Read more</a>
</div>
```

### Using Components with Imports

Unlike JX, JX requires explicit imports:

```jinja
{# components/dashboard.jinja #}
{#import "layout.jinja" as Layout #}
{#import "card.jinja" as Card #}
{#import "pagination.jinja" as Pagination #}
{#def products #}

<Layout title="My title">
  {% for product in products %}
    <Card title={{ product.title }} url={{ product.url }}>
      {{ product.description }}
    </Card>
  {% endfor %}
  <Pagination items={{ products }} />
</Layout>
```

### Arguments Definition

```jinja
{#def 
  title,              {# Required argument #}
  subtitle=None,      {# Optional with default #}
  size="md",          {# String default #}
  disabled=False      {# Boolean default #}
#}
```

### Content Slot

Use `{{ content }}` to render wrapped content:

```jinja
{# components/card.jinja #}
{#def title #}

<div class="card">
  <h2>{{ title }}</h2>
  <div class="card-body">
    {{ content }}
  </div>
</div>
```

Usage:

```jinja
<Card title="Welcome">
  <p>This content goes into {{ content }}</p>
</Card>
```

### Relative Imports

JX supports relative imports, making components portable:

```jinja
{#import "./button.jinja" as Button #}
{#import "../layout/base.jinja" as Base #}
```

## Benefits Over Macros/Include

| Feature          | JX Components           | Jinja Macros/Include |
| ---------------- | ----------------------- | -------------------- |
| **Dependencies** | Clear imports at top    | Hidden, scattered    |
| **Composable**   | Natural `{{ content }}` | Awkward `{% call %}` |
| **Type-Safe**    | Error at load time      | Error at render time |
| **Testable**     | Independent unit tests  | Coupled to templates |
| **Portable**     | Relative imports        | Path-dependent       |
| **Assets**       | Encapsulated CSS/JS     | Manual management    |

## HTMX Integration

HTMX enables AJAX interactions directly in HTML attributes.

### Basic Patterns

```jinja
{# components/ui/live-button.jinja #}
{#def endpoint, target, label #}

<button 
  hx-post="{{ endpoint }}"
  hx-target="{{ target }}"
  hx-swap="innerHTML"
  class="btn">
  {{ label }}
</button>
```

```jinja
{# components/ui/search.jinja #}
{#def endpoint, placeholder="Search..." #}

<div class="relative">
  <input 
    type="search"
    name="q"
    hx-get="{{ endpoint }}"
    hx-trigger="input changed delay:300ms, search"
    hx-target="#search-results"
    hx-indicator="#spinner"
    placeholder="{{ placeholder }}"
    class="w-full border rounded px-4 py-2">
  <span id="spinner" class="htmx-indicator">🔍</span>
</div>
<div id="search-results"></div>
```

### HTMX Attributes Reference

| Attribute      | Description                                         |
| -------------- | --------------------------------------------------- |
| `hx-get`       | GET request to URL                                  |
| `hx-post`      | POST request to URL                                 |
| `hx-put`       | PUT request to URL                                  |
| `hx-delete`    | DELETE request to URL                               |
| `hx-target`    | CSS selector for swap target                        |
| `hx-swap`      | How to swap (innerHTML, outerHTML, beforeend, etc.) |
| `hx-trigger`   | Event that triggers request                         |
| `hx-indicator` | Element to show during request                      |
| `hx-confirm`   | Confirmation dialog                                 |
| `hx-vals`      | Extra values to include                             |

### HTMX Triggers

```jinja
hx-trigger="click"                      {# Default for buttons #}
hx-trigger="input changed delay:300ms"  {# Debounced input #}
hx-trigger="revealed"                   {# When scrolled into view #}
hx-trigger="load"                       {# On element load #}
hx-trigger="every 5s"                   {# Polling #}
hx-trigger="intersect threshold:0.5"    {# Intersection observer #}
```

### Infinite Scroll Component

```jinja
{# components/features/infinite-scroll.jinja #}
{#def items, endpoint, next_page=None #}

{% for item in items %}
  <div class="item">{{ item.name }}</div>
{% endfor %}

{% if next_page %}
  <div 
    hx-get="{{ endpoint }}?page={{ next_page }}"
    hx-trigger="revealed"
    hx-swap="outerHTML"
    class="loading">
    Loading more...
  </div>
{% endif %}
```

### Inline Edit Component

```jinja
{# components/features/editable.jinja #}
{#def value, field, endpoint #}

<div 
  hx-get="{{ endpoint }}/edit"
  hx-trigger="click"
  hx-swap="outerHTML"
  class="cursor-pointer hover:bg-gray-50 p-2 rounded">
  {{ value }}
</div>
```

## Alpine.js Integration

Alpine.js handles client-side state and interactions.

### Basic Alpine Component

```jinja
{# components/ui/dropdown.jinja #}
{#def label #}

<div x-data="{ open: false }" @click.outside="open = false" class="relative">
  <button @click="open = !open" class="btn">
    {{ label }}
    <svg :class="{ 'rotate-180': open }" class="w-4 h-4 ml-2 transition-transform">
      <path d="M19 9l-7 7-7-7"/>
    </svg>
  </button>
  
  <div 
    x-show="open"
    x-transition:enter="transition ease-out duration-100"
    x-transition:enter-start="opacity-0 scale-95"
    x-transition:enter-end="opacity-100 scale-100"
    x-transition:leave="transition ease-in duration-75"
    x-transition:leave-start="opacity-100 scale-100"
    x-transition:leave-end="opacity-0 scale-95"
    class="absolute mt-2 w-48 bg-white rounded shadow-lg z-10">
    {{ content }}
  </div>
</div>
```

### Modal Component

```jinja
{# components/ui/modal.jinja #}
{#def title, id="modal" #}

<div 
  x-data="{ open: false }"
  @open-{{ id }}.window="open = true"
  @keydown.escape.window="open = false">
  
  {# Trigger slot #}
  <div @click="open = true">
    {{ caller(slot="trigger") if caller else "" }}
  </div>
  
  {# Modal #}
  <div 
    x-show="open"
    x-transition.opacity
    class="fixed inset-0 z-50 overflow-y-auto"
    style="display: none;">
    
    <div class="fixed inset-0 bg-black/50" @click="open = false"></div>
    
    <div class="relative min-h-screen flex items-center justify-center p-4">
      <div 
        x-show="open"
        x-transition:enter="transition ease-out duration-300"
        x-transition:enter-start="opacity-0 scale-95"
        x-transition:enter-end="opacity-100 scale-100"
        class="bg-white rounded-xl shadow-xl max-w-lg w-full">
        
        <div class="px-6 py-4 border-b flex justify-between items-center">
          <h3 class="text-lg font-semibold">{{ title }}</h3>
          <button @click="open = false" class="text-gray-400 hover:text-gray-600">&times;</button>
        </div>
        
        <div class="p-6">{{ content }}</div>
      </div>
    </div>
  </div>
</div>
```

### Tabs Component

```jinja
{# components/ui/tabs.jinja #}
{#def tabs, default_tab=None #}
{% set active = default_tab or tabs[0].id %}

<div x-data="{ activeTab: '{{ active }}' }">
  <div class="flex border-b">
    {% for tab in tabs %}
      <button 
        @click="activeTab = '{{ tab.id }}'"
        :class="{ 'border-b-2 border-blue-500 text-blue-600': activeTab === '{{ tab.id }}' }"
        class="px-4 py-2 font-medium text-gray-600 hover:text-gray-900">
        {{ tab.label }}
      </button>
    {% endfor %}
  </div>
  
  {% for tab in tabs %}
    <div x-show="activeTab === '{{ tab.id }}'" x-transition class="py-4">
      {{ tab.content }}
    </div>
  {% endfor %}
</div>
```

### Alpine Directives Reference

| Directive      | Description            |
| -------------- | ---------------------- |
| `x-data`       | Define component state |
| `x-show`       | Toggle visibility      |
| `x-if`         | Conditional render     |
| `x-for`        | Loop through items     |
| `x-bind` / `:` | Bind attributes        |
| `x-on` / `@`   | Event listeners        |
| `x-model`      | Two-way binding        |
| `x-text`       | Set text content       |
| `x-html`       | Set HTML content       |
| `x-transition` | CSS transitions        |
| `x-ref`        | Element reference      |
| `x-effect`     | React to state changes |

## Server-Sent Events (SSE)

Real-time server-to-client communication.

### HTMX SSE Extension

```html
<script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
```

### SSE Component

```jinja
{# components/features/live-feed.jinja #}
{#def endpoint #}

<div 
  hx-ext="sse"
  sse-connect="{{ endpoint }}"
  sse-swap="message:beforeend"
  class="space-y-2 max-h-96 overflow-y-auto">
  {# Messages will be appended here #}
</div>
```

### Toast Notifications with SSE

```jinja
{# components/features/toast-container.jinja #}
{#def sse_endpoint="/notifications" #}

<div 
  class="fixed bottom-4 right-4 space-y-2 z-50"
  x-data="{ 
    toasts: [],
    addToast(data) {
      const toast = JSON.parse(data)
      toast.id = Date.now()
      this.toasts.push(toast)
      setTimeout(() => this.removeToast(toast.id), 5000)
    },
    removeToast(id) {
      this.toasts = this.toasts.filter(t => t.id !== id)
    }
  }"
  hx-ext="sse"
  sse-connect="{{ sse_endpoint }}"
  @htmx:sse-message="addToast($event.detail.data)">
  
  <template x-for="toast in toasts" :key="toast.id">
    <div 
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0 translate-x-8"
      x-transition:enter-end="opacity-100 translate-x-0"
      x-transition:leave="transition ease-in duration-200"
      :class="{
        'bg-green-500': toast.type === 'success',
        'bg-red-500': toast.type === 'error',
        'bg-blue-500': toast.type === 'info'
      }"
      class="px-4 py-3 rounded-lg text-white shadow-lg flex items-center">
      <span x-text="toast.message"></span>
      <button @click="removeToast(toast.id)" class="ml-4">&times;</button>
    </div>
  </template>
</div>
```

### Python SSE Endpoint (Flask)

```python
from flask import Response, stream_with_context
import json
import time

@app.route('/notifications')
def notifications():
    def generate():
        while True:
            data = get_notification()  # Your logic
            if data:
                yield f"data: {json.dumps(data)}\n\n"
            time.sleep(1)
    
    return Response(
        stream_with_context(generate()),
        mimetype='text/event-stream',
        headers={'Cache-Control': 'no-cache'}
    )
```

### Python SSE Endpoint (FastAPI)

```python
from fastapi.responses import StreamingResponse
import asyncio
import json

@app.get("/notifications")
async def notifications():
    async def generate():
        while True:
            data = await get_notification()
            if data:
                yield f"data: {json.dumps(data)}\n\n"
            await asyncio.sleep(1)
    
    return StreamingResponse(
        generate(),
        media_type="text/event-stream"
    )
```

## TailwindCSS Integration

### Button Component

```jinja
{# components/ui/button.jinja #}
{#def 
  variant="primary",
  size="md",
  type="button",
  disabled=False
#}

{% set variants = {
  'primary': 'bg-blue-600 hover:bg-blue-700 text-white focus:ring-blue-500',
  'secondary': 'bg-gray-200 hover:bg-gray-300 text-gray-800 focus:ring-gray-500',
  'danger': 'bg-red-600 hover:bg-red-700 text-white focus:ring-red-500',
  'success': 'bg-green-600 hover:bg-green-700 text-white focus:ring-green-500',
  'ghost': 'bg-transparent hover:bg-gray-100 text-gray-700'
} %}

{% set sizes = {
  'sm': 'px-3 py-1.5 text-sm',
  'md': 'px-4 py-2 text-base',
  'lg': 'px-6 py-3 text-lg'
} %}

<button 
  type="{{ type }}"
  {% if disabled %}disabled{% endif %}
  class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed {{ variants[variant] }} {{ sizes[size] }}">
  {{ content }}
</button>
```

### Card Component

```jinja
{# components/ui/card.jinja #}
{#def title=None, footer=None, shadow="md" #}

{% set shadows = {
  'none': '',
  'sm': 'shadow-sm',
  'md': 'shadow-md',
  'lg': 'shadow-lg',
  'xl': 'shadow-xl'
} %}

<div class="bg-white rounded-xl {{ shadows[shadow] }} overflow-hidden">
  {% if title %}
    <div class="px-6 py-4 border-b border-gray-100">
      <h3 class="text-lg font-semibold text-gray-900">{{ title }}</h3>
    </div>
  {% endif %}
  
  <div class="p-6">
    {{ content }}
  </div>
  
  {% if footer %}
    <div class="px-6 py-4 border-t border-gray-100 bg-gray-50">
      {{ footer }}
    </div>
  {% endif %}
</div>
```

### Alert Component

```jinja
{# components/ui/alert.jinja #}
{#def type="info", dismissible=False #}

{% set types = {
  'info': 'bg-blue-50 text-blue-800 border-blue-200',
  'success': 'bg-green-50 text-green-800 border-green-200',
  'warning': 'bg-yellow-50 text-yellow-800 border-yellow-200',
  'error': 'bg-red-50 text-red-800 border-red-200'
} %}

{% set icons = {
  'info': 'ℹ️',
  'success': '✓',
  'warning': '⚠️',
  'error': '✕'
} %}

<div 
  {% if dismissible %}x-data="{ show: true }" x-show="show" x-transition{% endif %}
  class="flex items-start p-4 rounded-lg border {{ types[type] }}">
  <span class="mr-3 flex-shrink-0">{{ icons[type] }}</span>
  <div class="flex-1">{{ content }}</div>
  {% if dismissible %}
    <button @click="show = false" class="ml-3 opacity-70 hover:opacity-100">&times;</button>
  {% endif %}
</div>
```

## Base Layout Template

```jinja
{# components/layout/base.jinja #}
{#def title="My App" #}

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{ title }}</title>
  
  <!-- TailwindCSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- HTMX -->
  <script src="https://unpkg.com/htmx.org@2.0.0"></script>
  <script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
  
  <!-- Alpine.js -->
  <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="min-h-screen bg-gray-50">
  {{ content }}
</body>
</html>
```

## Project Structure

```bash
myapp/
├── app.py
├── components/
│   ├── layout/
│   │   ├── base.jinja
│   │   ├── header.jinja
│   │   └── footer.jinja
│   ├── ui/
│   │   ├── button.jinja
│   │   ├── card.jinja
│   │   ├── modal.jinja
│   │   ├── dropdown.jinja
│   │   ├── alert.jinja
│   │   └── tabs.jinja
│   ├── forms/
│   │   ├── input.jinja
│   │   ├── select.jinja
│   │   └── checkbox.jinja
│   ├── features/
│   │   ├── live-search.jinja
│   │   ├── infinite-scroll.jinja
│   │   └── toast-container.jinja
│   └── pages/
│       ├── home.jinja
│       └── dashboard.jinja
└── static/
```

## Flask Integration

```python
from flask import Flask
from jx import Catalog

app = Flask(__name__)
catalog = Catalog("components/")

# Add Flask globals to catalog
catalog.jinja_env.globals.update(app.jinja_env.globals)

@app.route("/")
def home():
    return catalog.render("pages/home.jinja", products=get_products())

@app.route("/api/search")
def search():
    query = request.args.get("q", "")
    results = search_products(query)
    return catalog.render("features/search-results.jinja", results=results)
```

## FastAPI Integration

```python
from fastapi import FastAPI
from jx import Catalog

app = FastAPI()
catalog = Catalog("components/")

@app.get("/")
async def home():
    products = await get_products()
    return catalog.render("pages/home.jinja", products=products)
```

## References

For detailed patterns and examples, see:

- `.agent/skills/python/jx/htmx.md` - Advanced HTMX patterns and examples
- `.agent/skills/python/jx/alpine.md` - Alpine.js component patterns
- `.agent/skills/python/jx/sse.md` - SSE setup and implementation patterns

## HTML-first Additional Notes
