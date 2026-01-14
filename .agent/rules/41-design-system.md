---
name: design-system
description: Design tokens, colors, typography, and responsive breakpoints. Use when styling components or creating new UI elements.
---

# Design System

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

---

## Typography

| Class   | Size/Weight     |
|---------|-----------------|
| `.h1`   | 2.5rem / bold   |
| `.h2`   | 2rem / semibold |
| `.h3`   | 1.5rem / medium |
| `.body` | 1rem / normal   |
| `.small`| 0.875rem        |
| `.tiny` | 0.75rem         |

### Fonts
- **Sans**: Inter, system-ui, -apple-system
- **Mono**: JetBrains Mono, Consolas

```css
body {
  font-family: Inter, system-ui, -apple-system, sans-serif;
}

code, pre, .mono {
  font-family: "JetBrains Mono", Consolas, monospace;
}

.h1 { font-size: 2.5rem; font-weight: 700; line-height: 1.2; }
.h2 { font-size: 2rem; font-weight: 600; line-height: 1.3; }
.h3 { font-size: 1.5rem; font-weight: 500; line-height: 1.4; }
.body { font-size: 1rem; line-height: 1.6; }
.small { font-size: 0.875rem; }
.tiny { font-size: 0.75rem; }
```

---

## Spacing Scale

| Token       | Value   |
|-------------|---------|
| `--space-1` | 0.25rem |
| `--space-2` | 0.5rem  |
| `--space-3` | 0.75rem |
| `--space-4` | 1rem    |
| `--space-5` | 1.5rem  |
| `--space-6` | 2rem    |

---

## Border Radius

| Token          | Value    |
|----------------|----------|
| `--radius-sm`  | 0.25rem  |
| `--radius-md`  | 0.5rem   |
| `--radius-lg`  | 0.75rem  |
| `--radius-pill`| 9999px   |

---

## Shadows

| Token        | Value                              |
|--------------|------------------------------------|
| `--shadow-sm`| `0 6px 16px rgba(0,0,0,0.18)`      |
| `--shadow-md`| `0 10px 30px rgba(0,0,0,0.22)`     |

---

## Responsive Breakpoints

| Breakpoint | Value    | Usage              |
|------------|----------|--------------------|
| `sm`       | 640px    | Mobile landscape   |
| `md`       | 768px    | Tablets            |
| `lg`       | 1024px   | Laptops            |
| `xl`       | 1280px   | Desktops           |
| `2xl`      | 1536px   | Large screens      |

### Tailwind usage

```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <!-- Responsive grid -->
</div>

<nav class="hidden md:flex">
  <!-- Desktop nav -->
</nav>

<button class="md:hidden">
  <!-- Mobile menu toggle -->
</button>
```
