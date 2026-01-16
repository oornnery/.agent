---
name: ui-components
description: Jx component library (Button, Card, Input, Tag, Icon, Navbar, EmptyState). Use when building or modifying UI components.
---

# UI Components

## Button

**Variants**: primary, secondary, ghost, danger  
**Sizes**: sm, md, lg  
**States**: default, hover, active, disabled, loading

### Jx Component

```jinja
{#def
  variant="primary",
  size="md",
  href=None,
  loading=False,
  disabled=False
#}
{% set base = "inline-flex items-center justify-center font-medium rounded-lg transition-all" %}

{% set variants = {
  "primary": "bg-[var(--accent)] text-white hover:brightness-110",
  "secondary": "bg-[var(--surface-2)] text-[var(--text)] hover:bg-[var(--border)]",
  "ghost": "bg-transparent text-[var(--text-2)] hover:text-[var(--text)] hover:bg-[var(--surface-2)]",
  "danger": "bg-[var(--danger)] text-white hover:brightness-110"
} %}

{% set sizes = {
  "sm": "px-3 py-1.5 text-sm",
  "md": "px-4 py-2",
  "lg": "px-6 py-3 text-lg"
} %}

{% if href and not disabled %}
<a
  href="{{ href }}"
  class="{{ base }} {{ variants[variant] }} {{ sizes[size] }}"
  {{ attrs.render() }}
>
  {{ content }}
</a>
{% else %}
<button
  {% if disabled or loading %}disabled{% endif %}
  class="{{ base }} {{ variants[variant] }} {{ sizes[size] }}
         {% if disabled or loading %}opacity-50 cursor-not-allowed{% endif %}"
  {{ attrs.render() }}
>
  {% if loading %}
    <svg class="animate-spin -ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
    </svg>
  {% endif %}
  {{ content }}
</button>
{% endif %}
```

### Usage

```jinja
<Button variant="primary" size="lg">Click me</Button>
<Button variant="ghost" href="/about">Learn more →</Button>
<Button variant="danger" hx-delete="/api/v1/posts/1" hx-confirm="Delete?">Delete</Button>
```

---

## Card

**Variants**: default, featured  
**Effects**: Hover lift + shadow

### Jx Component

```jinja
{#def title, href=None, variant="default", image=None #}
<article
  class="card-animated rounded-xl border border-[var(--border)] bg-[var(--surface)] overflow-hidden
         {% if variant == 'featured' %}ring-2 ring-[var(--accent)]{% endif %}"
  {{ attrs.render() }}
>
  {% if image %}
    <img src="{{ image }}" alt="{{ title }}" class="w-full h-48 object-cover" />
  {% endif %}
  <div class="p-5">
    <h3 class="h3 mb-2">{{ title }}</h3>
    <div class="text-[var(--text-2)]">
      {{ content }}
    </div>
    {% if href %}
      <a href="{{ href }}" class="mt-4 inline-block text-[var(--accent)] hover:underline">
        View →
      </a>
    {% endif %}
  </div>
</article>
```

### Usage

```jinja
<Card title="Project Name" href="/projects/1">
  Description here
</Card>

<Card title="Featured Project" variant="featured" image="/static/img/project.jpg">
  This is a highlighted project.
</Card>
```

---

## Tag

**Style**: Pill shape, mono font

### Jx Component

```jinja
{#def variant="default" #}
{% set variants = {
  "default": "bg-[var(--surface-2)] text-[var(--text-2)]",
  "accent": "bg-[var(--accent)]/20 text-[var(--accent)]",
  "success": "bg-[var(--accent-2)]/20 text-[var(--accent-2)]",
  "warn": "bg-[var(--warn)]/20 text-[var(--warn)]"
} %}
<span
  class="inline-block rounded-full px-3 py-1 font-mono text-xs {{ variants[variant] }}"
  {{ attrs.render() }}
>
  {{ content }}
</span>
```

### Usage

```jinja
<Tag>Python</Tag>
<Tag variant="accent">Featured</Tag>
<Tag variant="success">Published</Tag>
```

---

## Input

**Types**: text, email, password, textarea  
**States**: default, focus, error

### Jx Component

```jinja
{#def
  name,
  type="text",
  label=None,
  placeholder="",
  required=False,
  error=None,
  value=""
#}
<div class="space-y-1">
  {% if label %}
    <label for="{{ name }}" class="block text-sm font-medium text-[var(--text-2)]">
      {{ label }}{% if required %}<span class="text-[var(--danger)]">*</span>{% endif %}
    </label>
  {% endif %}

  {% if type == "textarea" %}
    <textarea
      id="{{ name }}"
      name="{{ name }}"
      placeholder="{{ placeholder }}"
      {% if required %}required{% endif %}
      class="w-full rounded-lg border bg-[var(--surface)] px-4 py-2 min-h-[120px]
             text-[var(--text)] placeholder:text-[var(--text-3)]
             focus:border-[var(--accent)] focus:outline-none focus:ring-1 focus:ring-[var(--accent)]
             {% if error %}border-[var(--danger)]{% else %}border-[var(--border)]{% endif %}"
      {{ attrs.render() }}
    >{{ value }}</textarea>
  {% else %}
    <input
      id="{{ name }}"
      name="{{ name }}"
      type="{{ type }}"
      value="{{ value }}"
      placeholder="{{ placeholder }}"
      {% if required %}required{% endif %}
      class="w-full rounded-lg border bg-[var(--surface)] px-4 py-2
             text-[var(--text)] placeholder:text-[var(--text-3)]
             focus:border-[var(--accent)] focus:outline-none focus:ring-1 focus:ring-[var(--accent)]
             {% if error %}border-[var(--danger)]{% else %}border-[var(--border)]{% endif %}"
      {{ attrs.render() }}
    />
  {% endif %}

  {% if error %}
    <p class="text-sm text-[var(--danger)]">{{ error }}</p>
  {% endif %}
</div>
```

### Usage

```jinja
<Input name="email" type="email" label="Email" placeholder="you@example.com" required />
<Input name="message" type="textarea" label="Message" placeholder="Your message..." />
<Input name="name" error="Name is required" />
```

---

## Icon

**Available**: github, linkedin, email, twitter, search, menu, plus, edit, trash, external-link, check, x, arrow-right

### Jx Component

```jinja
{#def name, size="md" #}
{% set sizes = {"sm": "w-4 h-4", "md": "w-5 h-5", "lg": "w-6 h-6", "xl": "w-8 h-8"} %}
<svg
  class="{{ sizes.get(size, sizes.md) }} inline-block"
  fill="none"
  stroke="currentColor"
  stroke-width="2"
  stroke-linecap="round"
  stroke-linejoin="round"
  {{ attrs.render() }}
>
  <use href="/static/icons.svg#{{ name }}"></use>
</svg>
```

### Usage

```jinja
<Icon name="github" size="lg" />
<Button variant="ghost"><Icon name="plus" size="sm" /> Add</Button>
```

---

## Navbar

**Features**: Sticky, blur background on scroll

### Jx Component

```jinja
{#def current_path="/" #}
{% set links = [
  {"href": "/", "label": "Home"},
  {"href": "/about", "label": "About"},
  {"href": "/projects", "label": "Projects"},
  {"href": "/blog", "label": "Blog"},
  {"href": "/contact", "label": "Contact"}
] %}
<nav class="sticky top-0 z-50 nav-blur border-b border-[var(--border)]">
  <div class="mx-auto max-w-5xl flex items-center justify-between px-6 py-4">
    <a href="/" class="font-bold text-xl text-[var(--text)]">Logo</a>
    <div class="hidden md:flex items-center gap-6">
      {% for link in links %}
        <a
          href="{{ link.href }}"
          class="text-sm transition
                 {% if current_path == link.href %}
                   text-[var(--accent)]
                 {% else %}
                   text-[var(--text-2)] hover:text-[var(--text)]
                 {% endif %}"
        >
          {{ link.label }}
        </a>
      {% endfor %}
    </div>
    <button class="md:hidden" id="mobile-menu-toggle">
      <Icon name="menu" />
    </button>
  </div>
</nav>
```

---

## EmptyState

**Features**: Icon + message + optional CTA

### Jx Component

```jinja
{#def icon="search", title, description=None, action_href=None, action_text="Get started" #}
<div class="flex flex-col items-center justify-center py-16 text-center">
  <div class="rounded-full bg-[var(--surface-2)] p-4 mb-4">
    <Icon name="{{ icon }}" size="xl" class="text-[var(--text-3)]" />
  </div>
  <h3 class="h3 mb-2">{{ title }}</h3>
  {% if description %}
    <p class="text-[var(--text-2)] max-w-md mb-6">{{ description }}</p>
  {% endif %}
  {% if action_href %}
    <Button href="{{ action_href }}">{{ action_text }}</Button>
  {% endif %}
</div>
```

### Usage

```jinja
<EmptyState
  icon="search"
  title="No projects found"
  description="Start by creating your first project."
  action_href="/admin/projects/new"
  action_text="Create Project"
/>
```
