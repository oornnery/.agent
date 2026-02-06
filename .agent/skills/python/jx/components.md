---
name: jx-components
description: >
  Project-specific JX + Jinja component catalog for the FastAPI monorepo. Use this skill when
  creating, modifying, or composing JX components, building page templates, wiring HTMX endpoints
  to partials, managing Alpine.js state in components, or working with the catalog system.
  Triggers include JX, Jinja component, catalog, page template, partial, layout, HTMX partial,
  SSE streaming, Alpine x-data, component props, slots, or hx-swap-oob.
---

# JX Component Catalog

Project-specific component reference for the FastAPI monorepo. All shared components live in `apps/packages/components/` with `@ui` prefix.

---

## Catalog System

### Building

```python
from apps.packages.catalog import build_catalog

catalog = build_catalog(
    app_components_dir=Path("apps/portfolio/components"),  # optional overrides
    debug=True,                                            # auto-reload in dev
    extra_global="value",                                  # template globals
)
# Mounts on app.state.catalog
```

### Rendering

```python
html = catalog.render("@ui/pages/Home.jinja", title="My App", heading="Welcome")
```

### Component Resolution

1. App-specific `components/` folder (highest priority)
2. Shared `apps/packages/components/` with `@ui` prefix
3. Global: `current_year` (auto-set by catalog)

---

## Component Tree

```text
@ui/
├── layouts/
│   ├── Layout.jinja          # Base HTML shell (head, body, scripts)
│   ├── Navbar.jinja           # Sticky header with brand + nav + theme toggle
│   ├── Content.jinja          # <main> wrapper
│   └── Footer.jinja           # Copyright + optional links
├── pages/
│   ├── Home.jinja             # Hello world landing page
│   ├── Health.jinja            # Live status dashboard with polling
│   └── Error.jinja             # 404 centered card
├── partials/
│   ├── Breadcrumb.jinja        # Trail navigation
│   ├── ThemeToggle.jinja       # Sun/Moon dark mode button
│   ├── Toast.jinja             # OOB notification with auto-dismiss
│   ├── HealthSummary.jinja     # Wrapper → HealthAccordion
│   ├── HealthAccordion.jinja   # Service list container
│   └── HealthAccordionItem.jinja  # Single service + SSE log viewer
└── ui/
    ├── Badge.jinja             # Pill label (neutral/success/danger)
    ├── Button.jinja            # Link or button (4 variants, 3 sizes)
    ├── Card.jinja              # Bordered panel with header/body/footer
    ├── Modal.jinja             # Dialog overlay with Alpine lifecycle
    └── StatusDot.jinja         # Colored circle indicator
```

---

## JX Syntax Reference

### Props

```jinja
{#def title="Default", count=0, items=[], active=false #}
```

### Imports

```jinja
{#import "@ui/ui/Card.jinja" as Card #}
```

### Usage

```jinja
<Card title="Hello">
  <p>Body content via {{ content }} slot</p>
  {% slot footer %}<button>Save</button>{% endslot %}
</Card>
```

### Attribute Spreading

```jinja
{# Pass extra HTML attrs from parent #}
<div {{ attrs.render(class="base-class") }}>
```

---

## Layout Components

### Layout

**File:** `layouts/Layout.jinja`
**Props:** `title="Fabio Souza"`, `lang="en"`, `description=""`, `navbar_links=None`, `brand=None`, `breadcrumb=None`

```text
Imports: Content, Footer, Navbar, Breadcrumb
Scripts: Tailwind CDN, HTMX, Idiomorph, Alpine.js
Body:    x-data="{ dark: false }" with localStorage persistence
Portals: #modal-portal, #toast-portal
```

Key behaviors:

- `tailwind.config = { darkMode: 'class' }` — MUST come AFTER CDN script
- `htmx:afterSwap` — skips `Alpine.initTree()` for morph swaps
- `hx-ext="morph"` on body enables Idiomorph globally

### Navbar

**File:** `layouts/Navbar.jinja`
**Props:** `brand="App"`, `img=None`, `links=None`
**Default links:** `[{label: 'Home', href: '/'}, {label: 'Status', href: '/status'}]`

```text
sticky top-0 z-40 border-b backdrop-blur-lg
  └─ Brand (img or initial avatar) + Nav links (gap-1) + ThemeToggle
```

- If no `img`: renders initial letter in `h-8 w-8 rounded-lg` avatar
- ThemeToggle separated by `border-l` divider

### Content

**File:** `layouts/Content.jinja`
**Props:** none

```html
<main class="w-full flex-1" role="main">{{ content }}</main>
```

### Footer

**File:** `layouts/Footer.jinja`
**Props:** `brand="App"`, `links=None`
**Globals used:** `current_year`

```text
border-t, max-w-6xl, flex row on sm+
  └─ © {year} {brand} + optional nav links
```

---

## UI Primitives

### Button

**File:** `ui/Button.jinja`
**Props:** `variant="primary"`, `size="md"`, `href=""`, `type="button"`
**Renders:** `<a>` if `href`, `<button>` otherwise

| Variant     | Light                      | Dark                       |
| ----------- | -------------------------- | -------------------------- |
| `primary`   | zinc-900 bg, white text    | zinc-50 bg, zinc-900 text  |
| `secondary` | zinc-100 bg, zinc-900 text | zinc-900 bg, zinc-100 text |
| `ghost`     | transparent, zinc-700 text | transparent, zinc-200 text |
| `danger`    | rose-600 bg, white text    | rose-500 bg, white text    |

| Size | Height | Padding | Font      |
| ---- | ------ | ------- | --------- |
| `sm` | h-9    | px-3    | text-sm   |
| `md` | h-10   | px-4    | text-sm   |
| `lg` | h-11   | px-5    | text-base |

```jinja
<Button variant="secondary" size="sm" href="/status">View status</Button>
<Button variant="danger" type="submit">Delete</Button>
<Button hx-get="/api/data" hx-target="#result">Load</Button>
```

### Badge

**File:** `ui/Badge.jinja`
**Props:** `tone="neutral"` (neutral | success | danger)

```text
rounded-full pill, px-2 py-0.5, text-xs font-medium, ring-1 ring-inset
```

```jinja
<Badge tone="success">Online</Badge>
<Badge tone="danger">DOWN</Badge>
```

### Card

**File:** `ui/Card.jinja`
**Props:** `title=""`, `subtitle=""`
**Slots:** `footer`

```text
┌──────────────────────────────────┐
│ Header: title + subtitle (px-5 py-4) │ ← border-b (if title/subtitle)
├──────────────────────────────────┤
│ Body: {{ content }}      (px-5 py-4) │
├──────────────────────────────────┤
│ Footer: {% slot footer %}        │ ← optional
└──────────────────────────────────┘
```

```jinja
<Card title="Users" subtitle="All registered users">
  <table>...</table>
  {% slot footer %}
    <Button size="sm">Add user</Button>
  {% endslot %}
</Card>
```

### Modal

**File:** `ui/Modal.jinja`
**Props:** `title=""`, `open=true`
**Slots:** `actions`

```text
z-50, max-w-lg, rounded-xl, shadow-xl
Overlay: zinc-950/60
Close:   Escape key, backdrop click, ✕ button
Cleanup: x-effect removes element when closed
```

```jinja
<Modal title="Confirm delete">
  <p>Are you sure?</p>
  {% slot actions %}
    <Button variant="ghost" @click="open = false">Cancel</Button>
    <Button variant="danger">Delete</Button>
  {% endslot %}
</Modal>
```

### StatusDot

**File:** `ui/StatusDot.jinja`
**Props:** `ok=false`

```text
h-2.5 w-2.5 rounded-full, aria-hidden="true"
ok=true  → emerald-500 / dark:emerald-400
ok=false → rose-500 / dark:rose-400
```

---

## Partials

### Breadcrumb

**File:** `partials/Breadcrumb.jinja`
**Props:** `items=[]` — list of `{label, href?}`

```jinja
{# Last item has no href → rendered as active (stronger text) #}
<Breadcrumb items={{ [
  {'label': 'Home', 'href': '/'},
  {'label': 'Status'}
] }} />
```

### ThemeToggle

**File:** `partials/ThemeToggle.jinja`
**Props:** none

```text
h-9 w-9 button with Sun (dark:block) / Moon (dark:hidden)
@click="dark = !dark" — toggles body-level Alpine state
```

### Toast

**File:** `partials/Toast.jinja`
**Props:** `message=""`, `tone="success"` (success | danger | neutral)

```text
Delivery: hx-swap-oob="true" → replaces #toast-portal
Position: fixed right-4 top-4 z-50
Duration: 3000ms auto-dismiss via setTimeout
```

Server-side usage:

```python
# Return toast alongside normal response
toast_html = catalog.render("@ui/partials/Toast.jinja", message="Saved!", tone="success")
return HTMLResponse(main_html + toast_html)
```

### HealthSummary

**File:** `partials/HealthSummary.jinja`
**Props:** `services=[]`
**Imports:** HealthAccordion

Thin wrapper: renders `<HealthAccordion services={{ services }} />`.
Target of `#healthz-summary` div in Health page for morph polling.

### HealthAccordion

**File:** `partials/HealthAccordion.jinja`
**Props:** `services=[]`
**Imports:** HealthAccordionItem

```html
<div id="healthz-accordion" class="overflow-hidden rounded-xl border ...">
  <div class="divide-y ...">
    {% for s in services %}<HealthAccordionItem service={{ s }} />{% endfor %}
  </div>
</div>
```

### HealthAccordionItem

**File:** `partials/HealthAccordionItem.jinja`
**Props:** `service=None` — object with `id`, `name`, `url`, `ok`, `code`, `datetime`
**Imports:** StatusDot, Badge

```text
id="healthz-item-{{ service.id }}" — stable ID for Idiomorph matching
Alpine x-data: { open, logs, es, connect(), disconnect(), toggle() }
SSE: EventSource('/healthz/logs/stream?service_id={{ service.id }}')
```

Key behaviors:

- `toggle()` → connects/disconnects SSE based on open state
- `@htmx:before-swap.window` → only disconnects when swap target is NOT `#healthz-summary`
- Chevron rotates 180° when open
- Log viewer: `<pre>` with `h-40 overflow-auto font-mono text-xs`

---

## Page Templates

### Home (`pages/Home.jinja`)

**Props:** `title="Home"`, `brand=None`, `heading="Hello, World!"`, `description="Your app is running..."`

```text
┌─────────────────────────────────────┐
│ Navbar [Brand] [Home] [Status] [☾]  │
├─────────────────────────────────────┤
│ Breadcrumb: Home                    │
│                                     │
│ ┌─ H1 ──────────────┐ ┌─Badge──┐   │
│ │ Hello, World!       │ │ Online │  │
│ └─────────────────────┘ └────────┘  │
│                                     │
│ ┌─ Card ──────────────────────┐     │
│ │ Description text             │    │
│ │ [View status] (secondary sm) │    │
│ └──────────────────────────────┘    │
├─────────────────────────────────────┤
│ Footer: © 2025 Brand                │
└─────────────────────────────────────┘
```

### Health (`pages/Health.jinja`)

**Props:** `title="Service health"`, `brand=None`, `summary_url="/healthz/summary"`, `request=None`

```text
┌─────────────────────────────────────┐
│ Navbar                              │
├─────────────────────────────────────┤
│ Breadcrumb: Home / Status           │
│                                     │
│ ┌─ H1 ────────┐     ┌──────────┐   │
│ │ Status       │     │ Refresh  │   │
│ └──────────────┘     └──────────┘   │
│                                     │
│ ┌─ Card ──────────────────────┐     │
│ │ #healthz-summary            │     │
│ │  hx-get=summary_url         │     │
│ │  hx-trigger="load, every 10s"│    │
│ │  hx-swap="morph:innerHTML"  │     │
│ │                              │     │
│ │  ┌─ Accordion ─────────────┐│     │
│ │  │ ● Portfolio [OK]  8000 ▼││     │
│ │  ├─────────────────────────┤│     │
│ │  │ ● Blog     [OK]  8001 ▼││     │
│ │  ├─────────────────────────┤│     │
│ │  │ ● Admin    [DOWN] 8002 ▼││     │
│ │  │   ┌─ Logs (SSE) ──────┐││     │
│ │  │   │ streaming...      │││     │
│ │  │   └───────────────────┘││     │
│ │  └─────────────────────────┘│     │
│ └──────────────────────────────┘    │
├─────────────────────────────────────┤
│ Footer                              │
└─────────────────────────────────────┘
```

### Error (`pages/Error.jinja`)

**Props:** `title="Error"`, `brand=None`, `error_title="Page not found"`, `message="The page you are..."`, `back_href="/"`, `home_href="/"`, `home_label="Go to Home"`

```text
┌─────────────────────────────────────┐
│ Navbar                              │
├─────────────────────────────────────┤
│                                     │
│              404                    │
│         (text-6xl zinc-200/800)     │
│                                     │
│       ┌─ Card (max-w-md) ─────┐    │
│       │ Page not found         │    │
│       │ The page you are...    │    │
│       │ [Go to Home] [Go back] │    │
│       └────────────────────────┘    │
├─────────────────────────────────────┤
│ Footer                              │
└─────────────────────────────────────┘
```

---

## HTMX Integration

### Endpoint → Partial Mapping

| Endpoint               | Renders                  | Swap Strategy     | Target               |
| ---------------------- | ------------------------ | ----------------- | -------------------- |
| `/healthz/summary`     | HealthSummary.jinja      | `morph:innerHTML` | `#healthz-summary`   |
| `/healthz/logs`        | Single health check JSON | —                 | —                    |
| `/healthz/logs/stream` | SSE `text/event-stream`  | EventSource (JS)  | Alpine `logs` state  |
| Form responses         | Main HTML + Toast.jinja  | `innerHTML` + OOB | form target + portal |

### Morph + Alpine Rules

1. Every Alpine-managed element MUST have a stable `id` for Idiomorph
2. `htmx:afterSwap` handler skips `Alpine.initTree()` when swap is `morph:*`
3. Only call `Alpine.initTree(e.target)` for non-morph swaps (new injected content)

### OOB Toast Pattern

```python
# Server returns both main content and toast via OOB
main = catalog.render("@ui/partials/SomePartial.jinja", data=data)
toast = catalog.render("@ui/partials/Toast.jinja", message="Done!", tone="success")
return HTMLResponse(main + toast)
```

---

## SSE Lifecycle

```text
User clicks accordion item
  → toggle()
    → open = true
      → connect()
        → new EventSource('/healthz/logs/stream?service_id=X')
        → onmessage: prepend to logs
        → onerror: disconnect()

User clicks again
  → toggle()
    → open = false
      → disconnect()
        → es.close(); es = null; logs = ''

HTMX morph swap fires
  → @htmx:before-swap.window
    → check if target is #healthz-summary
      → YES: do nothing (let morph preserve state)
      → NO: disconnect() (cleanup before DOM replace)
```

---

## Service Data Model

Health check services passed to HealthSummary/HealthAccordion:

```python
@dataclass
class ServiceStatus:
    id: str          # "portfolio", "blog", "admin"
    name: str        # "Portfolio"
    url: str         # "http://localhost:8000"
    ok: bool         # True if healthy
    code: int        # HTTP status code (200, 500, etc.)
    datetime: str    # ISO timestamp of last check
```

---

## Creating New Components

### UI Primitive

```jinja
{#def variant="default", size="md" #}

{% set base = "..." %}
{% set variants = { "default": "...", "alt": "..." } %}
{% set sizes = { "sm": "...", "md": "...", "lg": "..." } %}

<div {{ attrs.render(class=base ~ " " ~ variants.get(variant, variants["default"]) ~ " " ~ sizes.get(size, sizes["md"])) }}>
  {{ content }}
</div>
```

### Partial (HTMX target)

```jinja
{#import "@ui/ui/Card.jinja" as Card #}
{#def data=None #}

<div id="my-partial">
  <Card title="Data">
    {{ data }}
  </Card>
</div>
```

### Page Template

```jinja
{#import "@ui/layouts/Layout.jinja" as Layout #}
{#import "@ui/ui/Card.jinja" as Card #}
{#def title="Page", brand=None #}

<Layout
  title={{ title }}
  brand={{ brand or title }}
  breadcrumb={{ [{'label': 'Home', 'href': '/'}, {'label': 'Page'}] }}
>
  <section class="grid gap-6" aria-labelledby="page-title">
    <h1 id="page-title" class="text-2xl font-bold tracking-tight">{{ title }}</h1>
    <Card>
      {{ content }}
    </Card>
  </section>
</Layout>
```

### Route Handler

```python
@router.get("/my-page", response_class=HTMLResponse)
async def my_page(request: Request):
    catalog = request.app.state.catalog
    return catalog.render("@ui/pages/MyPage.jinja", title="My Page", request=request)
```
