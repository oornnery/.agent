---
name: jx
description: JX component architecture for HTML-first apps with project bootstrap, HTMX, Alpine.js, SSE, forms, and BFF patterns.
---

# JX Skill

Canonical guide for building and initializing JX projects.

This file consolidates the previous `core.md` and `init-project.md` into one entrypoint.

## Documentation

- FastAPI Docs: <https://fastapi.tiangolo.com/>
- HTMX Docs: <https://htmx.org/docs/>
- Alpine.js Docs: <https://alpinejs.dev/start-here>
- Alpine.js LLMs: <https://alpinejs.dev/llms.txt>
- MDN SSE: <https://developer.mozilla.org/docs/Web/API/Server-sent_events>

## Scope

- JX fundamentals and component syntax
- Project initialization (FastAPI/Flask)
- Catalog setup and rendering flow
- Frontend route/page creation and table documentation standard
- HTML-first interaction model (HTMX + Alpine + SSE)
- Forms and server-side validation
- BFF integration for UI-oriented aggregation

## Companion Files (Deeper Patterns)

Use these for specialized depth:

1. `.agent/skills/python/jx/components.md`
2. `.agent/skills/python/jx/htmx.md`
3. `.agent/skills/python/jx/alpine.md`
4. `.agent/skills/python/jx/sse.md`
5. `.agent/skills/python/jx/formidable.md`
6. `.agent/skills/python/jx/pydantic-forms.md`
7. `.agent/skills/python/jx/bff.md`

## JX Core Concepts

### Catalog Setup

```python
from jx import Catalog

catalog = Catalog("components/")

def render_home():
    return catalog.render("pages/home.jinja")
```

### Component Structure

Components are `.jinja` files with explicit props:

```jinja
{#def title, href #}
<div class="rounded border p-4">
  <h2>{{ title }}</h2>
  <div>{{ content }}</div>
  <a href="{{ href }}">Read more</a>
</div>
```

### Imports and Composition

```jinja
{#import "layout/base.jinja" as Base #}
{#import "ui/card.jinja" as Card #}
{#def products #}

<Base title="Dashboard">
  {% for p in products %}
    <Card title={{ p.title }} href={{ p.url }}>
      {{ p.summary }}
    </Card>
  {% endfor %}
</Base>
```

### Content Slot

- Use `{{ content }}` for wrapped body content.
- Prefer component composition over repeated page markup.

### Relative Imports

```jinja
{#import "./button.jinja" as Button #}
{#import "../layout/base.jinja" as Base #}
```

## Project Initialization

## Recommended Structure

```text
project/
  app.py or main.py
  components/
    layout/
      base.jinja
      header.jinja
    ui/
      button.jinja
      card.jinja
    features/
      live-search.jinja
      search-results.jinja
    pages/
      home.jinja
  static/
```

## Base Layout (Starter)

```jinja
{#def title="JX App" #}
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{{ title }}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/htmx.org@2.0.0"></script>
    <script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
  </head>
  <body class="min-h-screen bg-gray-50">
    {{ content }}
  </body>
</html>
```

## FastAPI Bootstrap

```python
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from jx import Catalog

app = FastAPI()
catalog = Catalog("components/")

@app.get("/", response_class=HTMLResponse)
async def home():
    return catalog.render("pages/home.jinja")
```

## Flask Bootstrap

```python
from flask import Flask
from jx import Catalog

app = Flask(__name__)
catalog = Catalog("components/")
catalog.jinja_env.globals.update(app.jinja_env.globals)

@app.get("/")
def home():
    return catalog.render("pages/home.jinja")
```

## Interaction Model (HTML-First)

### HTMX

- Use `hx-get` / `hx-post` for server interactions.
- Return JX partials for updates.
- Keep targets explicit with `hx-target`.

```jinja
<input
  name="q"
  hx-get="/search"
  hx-trigger="input changed delay:300ms"
  hx-target="#search-results"
  hx-swap="innerHTML" />
<div id="search-results"></div>
```

### Alpine.js

- Use Alpine only for local UI state and micro-interactions.
- Keep business logic and validation on server.

```jinja
<div x-data="{ open: false }">
  <button @click="open = !open">Toggle</button>
  <div x-show="open" x-transition>Content</div>
</div>
```

### SSE

- Use SSE for server push (notifications/live feeds).
- Render incoming updates as partials or append-only regions.

## Forms and Validation

- Validate inputs on server side.
- Return form partial with errors on `400`.
- Return success partial on valid submission.
- Prefer typed validation (Pydantic/Formidable contracts).

See `.agent/skills/python/jx/pydantic-forms.md` for a Pydantic-only form pattern.

## BFF in JX

- Build UI-specific view models in BFF layer.
- Aggregate upstream services and render JX partials/pages.
- Keep handlers thin and typed.

See `.agent/skills/python/jx/bff.md` for complete patterns.

## Pages and Routes Standard

Use this section as the canonical pattern to create and document frontend routes/pages in JX projects.

### Goal

1. Keep page routing consistent across the app.
2. Keep route/page inventory easy to scan.
3. Keep full-page vs partial behavior explicit for HTMX flows.

### JX Route Implementation Standard

#### Core Rules

- Page routes return HTML via `catalog.render(...)`.
- Group routes by concern (`public`, `admin`, `partials/actions`).
- Keep route handlers thin: fetch data, build page context, render.
- Put business logic in services/repositories, not in route handlers.
- Use explicit `response_class=HTMLResponse`.
- Raise HTTP errors explicitly for missing resources/auth failures.

#### Router Layout Pattern

```text
app/
  web/
    routes/
      public.py
      admin.py
      partials.py
  components/
    pages/
    admin/
    partials/
```

#### Public Router Example

```python
from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import HTMLResponse

router = APIRouter(tags=["web-public"])

@router.get("/", response_class=HTMLResponse)
async def home(request: Request) -> HTMLResponse:
    posts = await post_service.list_featured()
    return catalog.render("pages/Home", request=request, posts=posts)

@router.get("/projects/{project_id}", response_class=HTMLResponse)
async def project_detail(request: Request, project_id: int) -> HTMLResponse:
    project = await project_service.get_by_id(project_id)
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return catalog.render("pages/ProjectDetail", request=request, project=project)
```

#### Admin Router Example

```python
from fastapi import APIRouter, Depends, Request
from fastapi.responses import HTMLResponse

router = APIRouter(
    prefix="/admin",
    tags=["web-admin"],
    dependencies=[Depends(require_auth)],
)

@router.get("/", response_class=HTMLResponse)
async def admin_dashboard(request: Request) -> HTMLResponse:
    stats = await analytics_service.dashboard()
    return catalog.render("admin/Dashboard", request=request, stats=stats)
```

#### HTMX Partial Route Example

```python
from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse

router = APIRouter(prefix="/partials", tags=["web-partials"])

@router.get("/project-cards", response_class=HTMLResponse)
async def project_cards(request: Request, page: int = 1) -> HTMLResponse:
    items = await project_service.list_page(page=page, page_size=12)
    return catalog.render("partials/ProjectCards", request=request, items=items)
```

### JX Page/Route Documentation Contract (Tables)

Maintain route docs with tables in this format.

#### Required Columns

- `Method`
- `Route`
- `Component`
- `Layout`
- `Auth`
- `Response`
- `Data Source`
- `Description`

#### Optional Columns

- `HTMX Target`
- `Swap`
- `Notes`

#### Table Template

```md
## Public Routes

| Method | Route | Component | Layout | Auth | Response | Data Source | Description |
|---|---|---|---|---|---|---|---|
| GET | / | pages/Home | Public | public | full-page HTML | post_service.list_featured | Landing page |
| GET | /projects | pages/Projects | Public | public | full-page HTML | project_service.list_published | Projects list |
| GET | /projects/{project_id} | pages/ProjectDetail | Public | public | full-page HTML | project_service.get_by_id | Project details |
```

#### Example (Public + Admin + Partials)

##### Public Routes

| Method | Route | Component | Layout | Auth | Response | Data Source | Description |
|---|---|---|---|---|---|---|---|
| GET | `/` | `pages/Home` | `Public` | public | full-page HTML | `home_service.get_context` | Landing page |
| GET | `/blog` | `pages/Blog` | `Public` | public | full-page HTML | `post_service.list_published` | Blog list |
| GET | `/blog/{slug}` | `pages/PostDetail` | `Public` | public | full-page HTML | `post_service.get_by_slug` | Blog post detail |

##### Admin Routes

| Method | Route | Component | Layout | Auth | Response | Data Source | Description |
|---|---|---|---|---|---|---|---|
| GET | `/admin` | `admin/Dashboard` | `Admin` | required | full-page HTML | `analytics_service.dashboard` | Admin overview |
| GET | `/admin/blog` | `admin/BlogAdmin` | `Admin` | required | full-page HTML | `post_service.list_all` | Blog management |

##### Partial Routes (HTMX)

| Method | Route | Component | Layout | Auth | Response | Data Source | Description | HTMX Target | Swap |
|---|---|---|---|---|---|---|---|---|---|
| GET | `/partials/project-cards?page={n}` | `partials/ProjectCards` | n/a | public | partial HTML | `project_service.list_page` | Infinite scroll cards | `#project-grid` | `beforeend` |
| POST | `/contact/submit` | `partials/ContactForm` or `partials/ContactSuccess` | n/a | public | partial HTML | `contact_service.send_message` | Form validation + submit | `#contact-result` | `innerHTML` |

### Naming and Mapping Rules

- Route path uses kebab-case where possible.
- Component path uses PascalCase for page/admin components.
- `pages/*` and `admin/*` are full-page components.
- `partials/*` are fragment-only HTMX targets.
- Keep route params explicit (`{project_id}`, `{slug}`).

### Definition of Done

Before closing route/page work:

1. Route implemented with `response_class=HTMLResponse`.
2. Component path and layout are explicit and consistent.
3. Route appears in the route table with required columns.
4. For HTMX routes, target/swap behavior is documented.
5. Error states (404/403) are handled explicitly.

## Initialization Checklist

1. Create `components/` tree (`layout`, `ui`, `features`, `pages`).
2. Add `base.jinja` and one page (`pages/home.jinja`).
3. Configure `Catalog("components/")`.
4. Wire first route returning `catalog.render(...)`.
5. Add one HTMX partial flow.
6. Add one form with server-side validation.
7. Add one Alpine micro-interaction.

## Guardrails

- Keep JX as the single component model.
- Prefer reusable components over copied page markup.
- Keep full-page endpoints and partial endpoints explicit.
- Keep server-rendered HTML as source of truth for UI state.
