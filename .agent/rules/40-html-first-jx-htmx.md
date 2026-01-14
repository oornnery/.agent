---
name: html-first-jx-htmx
description: Server-rendered HTML with Jx/JinjaX components and HTMX. Use when building views, components, or handling HTMX requests.
---

# HTML-first (Jx/JinjaX + HTMX + Tailwind)

## Docs (links)
- Jx: https://github.com/jpsca/jx
- JinjaX: https://github.com/jpsca/jinjax
- HTMX: https://htmx.org
- Formidable: https://github.com/jpsca/formidable

## References (templates to learn from)
- Jinja boilerplate: https://github.com/app-generator/boilerplate-code-jinja
- FastAPI full-stack template: https://github.com/fastapi/full-stack-fastapi-template
- Tailwind landing page: https://github.com/cruip/tailwind-landing-page-template

---

## Minimal layout example

```jinja
{#def title #}
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{{ title }}</title>

    <!-- HTMX -->
    <script src="https://unpkg.com/htmx.org@2.0.4"></script>

    <!-- Tailwind (dev-only CDN; in prod prefer build pipeline) -->
    <script src="https://cdn.tailwindcss.com"></script>

    {{ assets.render_css() }}
  </head>
  <body class="min-h-dvh bg-zinc-950 text-zinc-100">
    <main class="mx-auto max-w-5xl p-6">
      {{ content }}
    </main>
    {{ assets.render_js() }}
  </body>
</html>
```

---

## Jx component examples

### HTMX Button component

```jinja
{#def text, url, target="#results", swap="innerHTML" #}
<button
  hx-get="{{ url }}"
  hx-target="{{ target }}"
  hx-swap="{{ swap }}"
  class="rounded-lg bg-teal-500 px-4 py-2 font-medium text-zinc-950 hover:bg-teal-400"
  {{ attrs.render() }}
>
  {{ text }}
</button>
```

### Items list component

```jinja
{#def items #}
<ul class="space-y-2">
  {% for item in items %}
    <li class="rounded-lg border border-zinc-800 bg-zinc-950/40 px-3 py-2">
      {{ item }}
    </li>
  {% endfor %}
</ul>
```

Usage:
```jinja
<Items items={{ items }} />
```

### Card component

```jinja
{#def title, href=None, variant="default" #}
<article
  class="card-animated rounded-xl border border-[var(--border)] bg-[var(--surface)] p-5
         {% if variant == 'featured' %}ring-2 ring-[var(--accent)]{% endif %}"
  {{ attrs.render() }}
>
  <h3 class="h3 mb-2">{{ title }}</h3>
  <div class="text-[var(--text-2)]">
    {{ content }}
  </div>
  {% if href %}
    <a href="{{ href }}" class="mt-4 inline-block text-[var(--accent)] hover:underline">
      View →
    </a>
  {% endif %}
</article>
```

### Tag component

```jinja
{#def variant="default" #}
<span
  class="inline-block rounded-full px-3 py-1 font-mono text-xs
         {% if variant == 'accent' %}
           bg-[var(--accent)]/20 text-[var(--accent)]
         {% else %}
           bg-[var(--surface-2)] text-[var(--text-2)]
         {% endif %}"
  {{ attrs.render() }}
>
  {{ content }}
</span>
```

### Input component

```jinja
{#def name, type="text", placeholder="", required=False, error=None #}
<div class="space-y-1">
  <input
    name="{{ name }}"
    type="{{ type }}"
    placeholder="{{ placeholder }}"
    {% if required %}required{% endif %}
    class="w-full rounded-lg border bg-[var(--surface)] px-4 py-2
           text-[var(--text)] placeholder:text-[var(--text-3)]
           focus:border-[var(--accent)] focus:outline-none focus:ring-1 focus:ring-[var(--accent)]
           {% if error %}border-[var(--danger)]{% else %}border-[var(--border)]{% endif %}"
    {{ attrs.render() }}
  />
  {% if error %}
    <p class="text-sm text-[var(--danger)]">{{ error }}</p>
  {% endif %}
</div>
```

### Icon component

```jinja
{#def name, size="md" #}
{% set sizes = {"sm": "w-4 h-4", "md": "w-5 h-5", "lg": "w-6 h-6"} %}
<svg class="{{ sizes.get(size, sizes.md) }} inline-block" {{ attrs.render() }}>
  <use href="/static/icons.svg#{{ name }}"></use>
</svg>
```

---

## Server pattern: full page vs partial

- **Browser hit** → render full page (layout + page)
- **HTMX hit** → return fragment only (partial)

Check `HX-Request` header (HTMX standard).

### FastAPI route examples

```python
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse

app = FastAPI()

# Full page route
@app.get("/", response_class=HTMLResponse)
def home(request: Request) -> str:
    return catalog.render("pages/Home", request=request)

# HTMX partial endpoint
@app.get("/partials/items", response_class=HTMLResponse)
def items_partial(request: Request) -> str:
    items = get_items()
    return catalog.render("partials/ItemsList", items=items)

# Detect HTMX requests
def is_htmx(request: Request) -> bool:
    return request.headers.get("HX-Request") == "true"

@app.get("/projects", response_class=HTMLResponse)
def projects(request: Request) -> str:
    projects = get_projects()
    if is_htmx(request):
        return catalog.render("partials/ProjectList", projects=projects)
    return catalog.render("pages/Projects", projects=projects)
```

---

## Forms: Formidable + HTMX

Pattern:
- Server validates
- Return partial with errors OR success fragment
- Use `hx-post` / `hx-trigger="blur"` for field-level validation

### Form definition

```python
from formidable import Form
from formidable.fields import Text, Email, Textarea

class ContactForm(Form):
    name = Text(required=True, min_length=2)
    email = Email(required=True)
    message = Textarea(required=True, min_length=10)
```

### Form template (HTMX-powered)

```jinja
<form hx-post="/api/v1/contact" hx-target="#form-result" hx-swap="innerHTML">
  <div class="space-y-4">
    {{ form.name }}
    {{ form.email }}
    {{ form.message }}
    <button
      type="submit"
      class="rounded-lg bg-teal-500 px-4 py-2 font-medium text-zinc-950 hover:bg-teal-400"
    >
      Send
    </button>
  </div>
</form>
<div id="form-result" class="mt-3"></div>
```

### FastAPI endpoint (returns fragment on error/success)

```python
from fastapi import Request
from fastapi.responses import HTMLResponse

@app.post("/api/v1/contact", response_class=HTMLResponse)
async def submit_contact(request: Request) -> HTMLResponse:
    form = ContactForm.from_request(request)

    if not form.is_valid():
        html = catalog.render("partials/ContactForm", form=form)
        return HTMLResponse(html, status_code=400)

    # Process form...
    await send_contact_email(form.data)

    return HTMLResponse("<p class='text-emerald-400'>Message sent!</p>")
```

---

## Jx Asset Pipeline (production)

Keep Tailwind source in `assets/`, build via CLI, register in Jx pipeline.

Structure:
```text
src/myapp/web/
  assets/
    tailwind.css
    app.js
  static/
    dist/
      app.css
      app.js
```

Layout switches from CDN to pipeline:
```jinja
{{ assets.render_css() }}
...
{{ assets.render_js() }}
```

Taskipy tasks:
```toml
[tool.taskipy.tasks]
build_css = "bunx tailwindcss -i src/myapp/web/assets/tailwind.css -o src/myapp/web/static/dist/app.css --minify"
serve_web = "uv run uvicorn myapp.main:app --reload --port 8000"
```

> **Rule**: dev may use CDN; production must use the pipeline.
