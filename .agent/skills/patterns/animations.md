---
name: animations
description: CSS animations, transitions, and HTMX loading states. Use when adding motion or interactive feedback to UI.
---

# Animations

## Keyframes

| Keyframe       | Description                        |
|----------------|------------------------------------|
| `fadeUp`       | Fade in + translate up             |
| `fadeIn`       | Simple opacity fade                |
| `slideInRight` | Slide in from right                |
| `scaleIn`      | Scale from 0.95 to 1               |

### CSS implementation (motion.css)

```css
@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes scaleIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}
```

---

## Utility Classes

| Class           | Effect                          |
|-----------------|---------------------------------|
| `.t`            | Base transition (all 200ms)     |
| `.enter`        | Entry animation (fadeUp)        |
| `.hover-lift`   | Lift on hover (translateY)      |
| `.hover-scale`  | Scale on hover (1.02)           |
| `.card-animated`| Card with hover lift + shadow   |
| `.nav-blur`     | Blur backdrop for navbar        |

```css
.t {
  transition: all 0.2s ease;
}

.enter {
  animation: fadeUp 0.4s ease-out forwards;
}

.hover-lift {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.hover-lift:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.hover-scale {
  transition: transform 0.15s ease;
}
.hover-scale:hover {
  transform: scale(1.02);
}

.card-animated {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.card-animated:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
}

.nav-blur {
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  background: rgba(11, 11, 13, 0.8);
}
```

---

## Stagger Delays

For sequential entry animations:

```css
.stagger-1 { animation-delay: 50ms; }
.stagger-2 { animation-delay: 100ms; }
.stagger-3 { animation-delay: 150ms; }
.stagger-4 { animation-delay: 200ms; }
.stagger-5 { animation-delay: 250ms; }
.stagger-6 { animation-delay: 300ms; }
```

### Usage example

```html
<div class="grid gap-6">
  <Card class="enter stagger-1">First</Card>
  <Card class="enter stagger-2">Second</Card>
  <Card class="enter stagger-3">Third</Card>
</div>
```

---

## HTMX Loading States

```css
/* Loading indicator */
.htmx-request .htmx-indicator {
  opacity: 1;
}

.htmx-indicator {
  opacity: 0;
  transition: opacity 0.2s ease;
}

/* Disable button during request */
.htmx-request button[type="submit"] {
  pointer-events: none;
  opacity: 0.6;
}
```

### Component with loading spinner

```jinja
<button
  type="submit"
  hx-post="/api/v1/contact"
  hx-indicator="#loading"
  class="btn-primary"
>
  <span>Send</span>
  <span id="loading" class="htmx-indicator ml-2">
    <svg class="animate-spin h-4 w-4" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"/>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/>
    </svg>
  </span>
</button>
```
