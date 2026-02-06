
# Design System Conventions

Generic, portable design system for Tailwind CSS projects. Inspired by [shadcn/ui](https://ui.shadcn.com/docs/components), [Basecoat UI](https://basecoatui.com/), [Preline](https://preline.co/), [Tailblocks](https://tailblocks.cc/), and [Common Webpage Layouts with TailwindCSS (Grid & Flexbox)](https://gist.github.com/devinschumacher/95ed32c383a8cc91c0e80e5e502b6afa).

Stack: [Tailwind CSS](https://tailwindcss.com/) + [HTMX](https://htmx.org/) + [Alpine.js](https://alpinejs.dev/) + [Idiomorph](https://github.com/bigskysoftware/idiomorph)

## 1. Color Strategy

### Neutral Scale

Pick ONE neutral and use it everywhere. Recommended: **Zinc**.

| Role              | Light tokens             | Dark tokens              |
|-------------------|--------------------------|--------------------------|
| Page background   | `{neutral}-50`           | `{neutral}-950`          |
| Surface (card)    | `white`                  | `{neutral}-950`          |
| Elevated surface  | `white/80` (translucent) | `{neutral}-950/80`       |
| Primary text      | `{neutral}-900`          | `{neutral}-50` or `100`  |
| Secondary text    | `{neutral}-600`          | `{neutral}-300` or `400` |
| Muted text        | `{neutral}-500`          | `{neutral}-400`          |
| Borders           | `{neutral}-200`          | `{neutral}-800`          |
| Dividers          | `{neutral}-200`          | `{neutral}-800`          |
| Hover bg          | `{neutral}-100`          | `{neutral}-900`          |
| Disabled          | `opacity-50`             | `opacity-50`             |

### Semantic Colors

Each semantic color follows the same pattern:

| Tone      | Color   | Light bg        | Light text      | Light ring      | Dark bg              | Dark text       | Dark ring       |
|-----------|---------|-----------------|-----------------|-----------------|----------------------|-----------------|-----------------|
| Success   | Emerald | `emerald-50`    | `emerald-800`   | `emerald-200`   | `emerald-900/30`     | `emerald-200`   | `emerald-800`   |
| Danger    | Rose    | `rose-50`       | `rose-800`      | `rose-200`      | `rose-900/30`        | `rose-200`      | `rose-800`      |
| Warning   | Amber   | `amber-50`      | `amber-800`     | `amber-200`     | `amber-900/30`       | `amber-200`     | `amber-800`     |
| Info      | Blue    | `blue-50`       | `blue-800`      | `blue-200`      | `blue-900/30`        | `blue-200`      | `blue-800`      |
| Neutral   | Zinc    | `zinc-50`       | `zinc-700`      | `zinc-200`      | `zinc-900`           | `zinc-200`      | `zinc-700`      |

**Pattern**: Dark backgrounds use `{color}-900/30` (30% opacity) for subtlety.

### Status Indicators

| State   | Light           | Dark            |
|---------|-----------------|-----------------|
| OK/Up   | `emerald-500`   | `emerald-400`   |
| Down    | `rose-500`      | `rose-400`      |
| Warning | `amber-500`     | `amber-400`     |

## 3. Spacing System

### Base Grid: 4px

All spacing values are multiples of 4px via Tailwind's default scale.

### Container Pattern

```txt
max-w-{size} mx-auto w-full px-4
```

| Container    | Width  | Use                     |
|--------------|--------|--------------------------|
| `max-w-sm`   | 384px  | Auth forms, small dialogs|
| `max-w-md`   | 448px  | Centered error cards     |
| `max-w-lg`   | 512px  | Modals                   |
| `max-w-2xl`  | 672px  | Blog content             |
| `max-w-4xl`  | 896px  | Dashboard content        |
| `max-w-6xl`  | 1152px | Full-width app layouts   |

### Padding Conventions

| Context          | Token   | Value |
|------------------|---------|-------|
| Page horizontal  | `px-4`  | 16px  |
| Card body        | `px-5 py-4` | 20/16px |
| Button sm        | `px-3`  | 12px  |
| Button md        | `px-4`  | 16px  |
| Button lg        | `px-5`  | 20px  |
| Badge            | `px-2 py-0.5` | 8/2px |
| Navbar           | `py-3`  | 12px  |
| Footer           | `py-4`  | 16px  |
| Content area     | `py-6`  | 24px  |

### Gap Conventions

| Token   | Value | Use                              |
|---------|-------|----------------------------------|
| `gap-1` | 4px   | Inline items (nav, icon+text)    |
| `gap-2` | 8px   | Button groups, breadcrumbs       |
| `gap-3` | 12px  | Logo+brand, form fields          |
| `gap-4` | 16px  | Card grid items                  |
| `gap-6` | 24px  | Page sections                    |
| `gap-8` | 32px  | Major layout sections            |

## 5. Shadows

| Token       | Use                    | Elevation  |
|-------------|------------------------|------------|
| (none)      | Flat elements          | Ground     |
| `shadow-sm` | Cards, panels          | Surface    |
| `shadow-md` | Toasts, floating menus | Floating   |
| `shadow-lg` | Dropdowns, popovers    | Raised     |
| `shadow-xl` | Modals, overlays       | Overlay    |

```txt
Ground → Surface (sm) → Floating (md) → Raised (lg) → Overlay (xl)
```

## 7. Z-Index Layers

| Layer     | Z-Index | Elements                |
|-----------|---------|--------------------------|
| Base      | auto    | Page content             |
| Dropdown  | `z-10`  | Dropdowns, popovers      |
| Sticky    | `z-30`  | Sticky sidebars          |
| Navbar    | `z-40`  | Fixed/sticky navbar      |
| Overlay   | `z-50`  | Modals, toasts, drawers  |

## 9. Dark Mode

### Implementation

```txt
Method:   Tailwind class-based (darkMode: 'class')
Storage:  localStorage key "theme" → "dark" | "light"
Default:  prefers-color-scheme media query fallback
Toggle:   Alpine.js x-data on <body>, $watch syncs to <html>
```

### Inversion Rules

| Element          | Light → Dark transformation              |
|------------------|------------------------------------------|
| Page bg          | `{neutral}-50` → `{neutral}-950`        |
| Surface bg       | `white` → `{neutral}-950`               |
| Translucent bg   | `white/80` → `{neutral}-950/80`         |
| Primary button   | `{neutral}-900` bg → `{neutral}-50` bg  |
| Semantic bg      | `{color}-50` → `{color}-900/30`         |
| Borders          | `{neutral}-200` → `{neutral}-800`       |
| Primary text     | `{neutral}-900` → `{neutral}-50`        |
| Hover bg         | `{neutral}-100` → `{neutral}-900`       |

## 11. Layout Patterns

### Page Grid

```bash
┌──────────────────────────────────────┐
│ Navbar (sticky, z-40, backdrop-blur) │
├──────────────────────────────────────┤
│ Content (flex-1, max-w-{size} px-4)  │
│  ┌──────────────────────────────┐    │
│  │  Breadcrumb (optional)       │    │
│  │  Page section (grid gap-6)   │    │
│  │    ┌──────────────────┐      │    │
│  │    │ Card / Content   │      │    │
│  │    └──────────────────┘      │    │
│  └──────────────────────────────┘    │
├──────────────────────────────────────┤
│ Footer (border-t)                    │
└──────────────────────────────────────┘
```

### Navbar

```text
sticky top-0 z-40 border-b bg-{surface}/80 backdrop-blur-lg
  └─ max-w-{size} mx-auto px-4
       ├─ Brand (logo/initial + name)
       ├─ Nav links (gap-1, rounded-md hover)
       └─ Actions (theme toggle, user menu)
```

### Body Structure

```html
<body class="flex min-h-screen flex-col bg-{neutral}-50 dark:bg-{neutral}-950">
  <header>Navbar</header>
  <main class="w-full flex-1">Content</main>
  <footer>Footer</footer>
  <div id="modal-portal"></div>
  <div id="toast-portal"></div>
</body>
```

### Common Responsive Layouts

Use **CSS Grid** for page-level layout, **Flexbox** for component-level alignment.

#### One-Column (Header + Content + Footer)

```html
<div class="flex min-h-screen flex-col">
  <header class="bg-blue-500 p-4">Header</header>
  <main class="flex-grow p-4">Content</main>
  <footer class="bg-gray-300 p-4">Footer</footer>
</div>
```

#### Two-Column (Content + Right Sidebar)

```html
<div class="flex min-h-screen flex-col">
  <header class="bg-blue-500 p-4">Header</header>
  <div class="flex flex-grow flex-col md:flex-row">
    <main class="order-2 flex-grow p-4 md:order-1">Content</main>
    <aside class="order-1 w-full bg-gray-200 p-4 md:order-2 md:w-64">Sidebar</aside>
  </div>
  <footer class="bg-gray-300 p-4">Footer</footer>
</div>
```

#### Two-Column (Left Sidebar + Content)

```html
<div class="flex min-h-screen flex-col">
  <header class="bg-blue-500 p-4">Header</header>
  <div class="flex flex-grow flex-row">
    <aside class="hidden w-64 bg-gray-200 p-4 sm:block">Sidebar</aside>
    <main class="flex-grow p-4">Content</main>
  </div>
  <footer class="bg-gray-300 p-4">Footer</footer>
</div>
```

#### Three-Column (Left Sidebar + Content + Right Sidebar)

```html
<div class="grid min-h-screen grid-cols-1 grid-rows-[auto,1fr,auto] md:grid-cols-[200px,1fr] lg:grid-cols-[200px,1fr,200px]">
  <header class="col-span-full bg-blue-500 p-4">Header</header>
  <aside class="hidden bg-gray-200 p-4 md:row-start-2 md:block">Left Sidebar</aside>
  <main class="row-start-2 bg-white p-4 md:col-start-2">Content</main>
  <aside class="hidden bg-gray-200 p-4 lg:row-start-2 lg:block">Right Sidebar</aside>
  <footer class="col-span-full bg-gray-300 p-4">Footer</footer>
</div>
```

#### Dashboard (Collapsible Sidebar)

```css
grid-template-areas:
  'nav header header'
  'nav content sidebar'
  'nav footer footer';
```

Ideal for admin panels. Sidebar collapses on mobile via responsive grid columns.

### Layout Decision Tree

```txt
Single content column?          → Flexbox (flex-col min-h-screen)
Content + sidebar?              → Flexbox (flex-row on md+, stacked on mobile)
Content + 2 sidebars?           → CSS Grid (grid-cols responsive breakpoints)
Dashboard with collapsible nav? → CSS Grid (grid-template-areas)
```

## 13. Alpine.js State Patterns

| Pattern    | x-data               | Behavior                               |
|------------|-----------------------|-----------------------------------------|
| Dark mode  | `{ dark: false }`    | $watch syncs to html class + localStorage |
| Modal      | `{ open: true }`     | Escape/backdrop close, x-effect remove |
| Toast      | `{ show: true }`     | setTimeout auto-dismiss                |
| Accordion  | `{ open: false }`    | Toggle content, cleanup on close       |
| Dropdown   | `{ open: false }`    | Click-away close via @click.outside    |
| Tabs       | `{ tab: 'first' }`  | Show/hide panels, :class binding       |

### SSE Lifecycle Pattern

```text
User action  → connect()    → new EventSource(url)
                              → onmessage: update state
                              → onerror: disconnect()
User action  → disconnect() → es.close(), es = null
Page leaving → disconnect() → cleanup before DOM replace
```

---

## Token Presets (Merged)

## Design System

## Color Palette

### Dark Theme (default)

| Token        | Value     | Usage                    |
|--------------|-----------|--------------------------|
| `--bg`       | `#0b0b0d` | Page background          |
| `--surface`  | `#121215` | Card/panel backgrounds   |
| `--surface-2`| `#1a1a1f` | Elevated surfaces        |
| `--text`     | `#ededed` | Primary text             |
| `--text-2`   | `#a1a1aa` | Secondary text           |
| `--text-3`   | `#6b7280` | Muted/placeholder text   |
| `--border`   | `#1f1f26` | Borders, dividers        |
| `--accent`   | `#7c7cff` | Primary accent (links)   |
| `--accent-2` | `#22c55e` | Secondary accent (success)|
| `--warn`     | `#f59e0b` | Warnings                 |
| `--danger`   | `#ef4444` | Errors, destructive      |

### Light Theme

| Token        | Value     |
|--------------|-----------|
| `--bg`       | `#fafafa` |
| `--surface`  | `#ffffff` |
| `--surface-2`| `#f4f4f5` |
| `--text`     | `#0f172a` |
| `--accent`   | `#4f46e5` |

### CSS implementation (tokens.css)

```css
:root {
  /* Dark theme (default) */
  --bg: #0b0b0d;
  --surface: #121215;
  --surface-2: #1a1a1f;
  --text: #ededed;
  --text-2: #a1a1aa;
  --text-3: #6b7280;
  --border: #1f1f26;
  --accent: #7c7cff;
  --accent-2: #22c55e;
  --warn: #f59e0b;
  --danger: #ef4444;
}

[data-theme="light"] {
  --bg: #fafafa;
  --surface: #ffffff;
  --surface-2: #f4f4f5;
  --text: #0f172a;
  --text-2: #71717a;
  --text-3: #a1a1aa;
  --border: #e4e4e7;
  --accent: #4f46e5;
}
```

## Spacing Scale

| Token       | Value   |
|-------------|---------|
| `--space-1` | 0.25rem |
| `--space-2` | 0.5rem  |
| `--space-3` | 0.75rem |
| `--space-4` | 1rem    |
| `--space-5` | 1.5rem  |
| `--space-6` | 2rem    |

## Shadows

| Token        | Value                              |
|--------------|------------------------------------|
| `--shadow-sm`| `0 6px 16px rgba(0,0,0,0.18)`      |
| `--shadow-md`| `0 10px 30px rgba(0,0,0,0.22)`     |
