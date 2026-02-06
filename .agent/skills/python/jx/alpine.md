---
name: jx-alpine
description: >
  Alpine.js patterns and reference for JX components. Use this skill when implementing
  client-side interactivity like dropdowns, modals, accordions, tabs, toasts, form validation,
  transitions, or global stores. Triggers include x-data, x-show, x-if, x-for, x-model,
  x-bind, x-on, @click, Alpine directives, or client-side state management in Jinja templates.
---

# Alpine.js Patterns Reference for JX

## Core Directives

### x-data - Component State

```jinja
{# Basic state #}
<div x-data="{ open: false, count: 0 }">
  ...
</div>

{# With methods #}
<div x-data="{ 
  count: 0,
  increment() { this.count++ },
  decrement() { this.count-- }
}">
  <button @click="decrement">-</button>
  <span x-text="count"></span>
  <button @click="increment">+</button>
</div>

{# External function #}
<div x-data="dropdown()">...</div>
<script>
function dropdown() {
  return {
    open: false,
    toggle() { this.open = !this.open },
    close() { this.open = false }
  }
}
</script>
```

### x-show vs x-if

```jinja
{# x-show: toggles CSS display (element stays in DOM) #}
<div x-show="open">Visible when open</div>

{# x-if: conditionally renders (removes from DOM) #}
<template x-if="loggedIn">
  <span>Welcome, user!</span>
</template>
```

### x-for - Loops

```jinja
<template x-for="item in items" :key="item.id">
  <div x-text="item.name"></div>
</template>

{# With index #}
<template x-for="(item, index) in items" :key="index">
  <div>
    <span x-text="index + 1"></span>. 
    <span x-text="item.name"></span>
  </div>
</template>
```

### x-bind - Attribute Binding

```jinja
{# Full syntax #}
<div x-bind:class="{ 'active': isActive }"></div>

{# Shorthand #}
<div :class="{ 'active': isActive, 'disabled': isDisabled }"></div>
<div :class="isActive ? 'bg-green-500' : 'bg-gray-500'"></div>
<div :style="{ color: textColor, fontSize: size + 'px' }"></div>
<input :disabled="isLoading">
<a :href="url">Link</a>
```

### x-on - Event Handling

```jinja
{# Full syntax #}
<button x-on:click="open = true">Open</button>

{# Shorthand #}
<button @click="open = true">Open</button>
<button @click="count++">+</button>
<button @click="handleClick($event)">Click</button>

{# Modifiers #}
<button @click.prevent="submit()">No default</button>
<button @click.stop="action()">Stop propagation</button>
<div @click.outside="close()">Click outside to close</div>
<button @click.once="runOnce()">Run once</button>
<input @input.debounce.300ms="search()">
<div @scroll.throttle.500ms="onScroll()">

{# Keyboard #}
<input @keydown.enter="submit()">
<input @keydown.escape="close()">
<input @keydown.arrow-up="prev()">
<input @keydown.ctrl.s.prevent="save()">

{# Window events #}
<div @resize.window="handleResize()"></div>
<div @scroll.window="handleScroll()"></div>
```

### x-model - Two-way Binding

```jinja
<input type="text" x-model="name">
<input type="checkbox" x-model="agreed">
<textarea x-model="message"></textarea>

<select x-model="selected">
  <option value="a">Option A</option>
  <option value="b">Option B</option>
</select>

{# Modifiers #}
<input x-model.lazy="name">      {# Update on blur #}
<input x-model.number="count">   {# Cast to number #}
<input x-model.debounce="query"> {# Debounced #}
```

### x-text / x-html

```jinja
<span x-text="message"></span>
<div x-html="htmlContent"></div>
```

### x-ref - Element References

```jinja
<input x-ref="searchInput">
<button @click="$refs.searchInput.focus()">Focus</button>
```

### x-init - Initialization

```jinja
<div x-data="{ items: [] }" x-init="items = await fetchItems()">
  <template x-for="item in items">
    <div x-text="item.name"></div>
  </template>
</div>

{# Also runs on Alpine init #}
<div x-init="console.log('Component initialized')">
```

### x-effect - Reactive Effects

```jinja
<div 
  x-data="{ query: '' }" 
  x-effect="if (query.length > 2) search(query)">
  <input x-model="query">
</div>
```

## Transitions

```jinja
{# Basic transition #}
<div x-show="open" x-transition>Content</div>

{# Custom transition #}
<div 
  x-show="open"
  x-transition:enter="transition ease-out duration-300"
  x-transition:enter-start="opacity-0 transform scale-95"
  x-transition:enter-end="opacity-100 transform scale-100"
  x-transition:leave="transition ease-in duration-200"
  x-transition:leave-start="opacity-100 transform scale-100"
  x-transition:leave-end="opacity-0 transform scale-95">
  Modal content
</div>

{# Shorthand modifiers #}
<div x-show="open" x-transition.opacity>Fade only</div>
<div x-show="open" x-transition.scale.80>Scale from 80%</div>
<div x-show="open" x-transition.duration.500ms>500ms duration</div>
```

## Magic Properties

| Property    | Description                |
| ----------- | -------------------------- |
| `$el`       | Current element            |
| `$refs`     | Object of x-ref elements   |
| `$store`    | Global Alpine store        |
| `$watch`    | Watch for property changes |
| `$dispatch` | Dispatch custom events     |
| `$nextTick` | Run code after DOM update  |
| `$root`     | Root x-data element        |
| `$data`     | Component data object      |
| `$id`       | Generate unique ID         |

```jinja
{# Dispatch custom event #}
<button @click="$dispatch('notify', { message: 'Hello!' })">
  Notify
</button>
<div @notify.window="alert($event.detail.message)">
  Listener
</div>

{# Watch property #}
<div x-data="{ name: '' }">
  <input x-model="name">
  <span x-init="$watch('name', value => console.log('Name:', value))"></span>
</div>

{# Next tick #}
<button @click="open = true; $nextTick(() => $refs.input.focus())">
  Open and focus
</button>
```

## Global Store

```html
<script>
document.addEventListener('alpine:init', () => {
  Alpine.store('user', {
    name: 'Guest',
    loggedIn: false,
    login(name) {
      this.name = name;
      this.loggedIn = true;
    },
    logout() {
      this.name = 'Guest';
      this.loggedIn = false;
    }
  });
});
</script>

<div x-data>
  <span x-show="$store.user.loggedIn" x-text="$store.user.name"></span>
  <button x-show="!$store.user.loggedIn" @click="$store.user.login('John')">
    Login
  </button>
</div>
```

## JX Component Patterns

### Dropdown

```jinja
{# components/ui/dropdown.jinja #}
{#def label #}

<div 
  x-data="{ open: false }"
  @click.outside="open = false"
  @keydown.escape.window="open = false"
  class="relative inline-block">

  <button 
    @click="open = !open"
    class="px-4 py-2 bg-white border rounded-lg shadow-sm hover:bg-gray-50">
    {{ label }}
    <svg 
      :class="{ 'rotate-180': open }"
      class="inline w-4 h-4 ml-2 transition-transform">
      <path d="M7 10l5 5 5-5z"/>
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
    class="absolute left-0 mt-2 w-48 bg-white rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 z-10">
    {{ content }}
  </div>
</div>
```

### Accordion

```jinja
{# components/ui/accordion.jinja #}
{#def allow_multiple=False #}

<div 
  x-data="{ 
    active: {% if allow_multiple %}[]{% else %}null{% endif %},
    toggle(id) {
      {% if allow_multiple %}
      if (this.active.includes(id)) {
        this.active = this.active.filter(i => i !== id)
      } else {
        this.active.push(id)
      }
      {% else %}
      this.active = this.active === id ? null : id
      {% endif %}
    },
    isOpen(id) {
      {% if allow_multiple %}
      return this.active.includes(id)
      {% else %}
      return this.active === id
      {% endif %}
    }
  }"
  class="divide-y divide-gray-200 border rounded-lg">
  {{ content }}
</div>
```

```jinja
{# components/ui/accordion-item.jinja #}
{#def id, title #}

<div>
  <button 
    @click="toggle('{{ id }}')"
    class="w-full px-4 py-3 flex justify-between items-center text-left hover:bg-gray-50">
    <span class="font-medium">{{ title }}</span>
    <svg 
      :class="{ 'rotate-180': isOpen('{{ id }}') }"
      class="w-5 h-5 transition-transform">
      <path d="M19 9l-7 7-7-7"/>
    </svg>
  </button>
  <div 
    x-show="isOpen('{{ id }}')"
    x-collapse
    class="px-4 py-3 bg-gray-50">
    {{ content }}
  </div>
</div>
```

### Notification Toast

```jinja
{# components/features/toasts.jinja #}

<div 
  x-data="{
    toasts: [],
    add(toast) {
      const id = Date.now()
      this.toasts.push({ id, ...toast })
      setTimeout(() => this.remove(id), toast.duration || 5000)
    },
    remove(id) {
      this.toasts = this.toasts.filter(t => t.id !== id)
    }
  }"
  @toast.window="add($event.detail)"
  class="fixed bottom-4 right-4 z-50 space-y-2">

  <template x-for="toast in toasts" :key="toast.id">
    <div 
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0 translate-x-8"
      x-transition:enter-end="opacity-100 translate-x-0"
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0 translate-x-8"
      :class="{
        'bg-green-500': toast.type === 'success',
        'bg-red-500': toast.type === 'error',
        'bg-blue-500': toast.type === 'info',
        'bg-yellow-500': toast.type === 'warning'
      }"
      class="px-4 py-3 rounded-lg text-white shadow-lg flex items-center min-w-64">
      <span x-text="toast.message" class="flex-1"></span>
      <button @click="remove(toast.id)" class="ml-4 hover:opacity-75">&times;</button>
    </div>
  </template>
</div>
```

Trigger from anywhere:

```jinja
<button @click="$dispatch('toast', { 
  type: 'success', 
  message: 'Item saved successfully!' 
})">
  Save
</button>
```

### Form Validation

```jinja
{# components/forms/validated-input.jinja #}
{#def name, label, type="text", required=False, min_length=None, pattern=None #}

<div x-data="{
  value: '',
  error: '',
  touched: false,
  validate() {
    this.touched = true
    {% if required %}
    if (!this.value.trim()) {
      this.error = '{{ label }} is required'
      return false
    }
    {% endif %}
    {% if min_length %}
    if (this.value.length < {{ min_length }}) {
      this.error = 'Minimum {{ min_length }} characters'
      return false
    }
    {% endif %}
    {% if pattern %}
    if (!{{ pattern }}.test(this.value)) {
      this.error = 'Invalid format'
      return false
    }
    {% endif %}
    this.error = ''
    return true
  }
}" class="space-y-1">
  <label class="block text-sm font-medium text-gray-700">
    {{ label }}{% if required %} *{% endif %}
  </label>
  <input 
    type="{{ type }}"
    name="{{ name }}"
    x-model="value"
    @blur="validate()"
    :class="{ 'border-red-500 focus:ring-red-500': touched && error }"
    class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
  <p x-show="touched && error" x-text="error" class="text-sm text-red-500"></p>
</div>
```

## HTMX + Alpine Integration

### Loading State

```jinja
<div 
  x-data="{ loading: false }"
  @htmx:before-request="loading = true"
  @htmx:after-request="loading = false">

  <button 
    hx-get="/api/data"
    hx-target="#results"
    :disabled="loading"
    class="btn">
    <span x-show="!loading">Load Data</span>
    <span x-show="loading">Loading...</span>
  </button>

  <div id="results"></div>
</div>
```

### Alpine State from HTMX Response

```jinja
<div 
  x-data="{ count: 0 }"
  @htmx:after-swap="
    const newCount = $event.detail.xhr.getResponseHeader('X-Count')
    if (newCount) count = parseInt(newCount)
  ">
  <span>Count: <span x-text="count"></span></span>
  <button hx-post="/api/increment" hx-swap="none">+</button>
</div>
```

### Form with Alpine Validation + HTMX Submit

```jinja
<form 
  x-data="{
    email: '',
    isValid: false,
    validate() {
      this.isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)
      return this.isValid
    }
  }"
  @submit.prevent="if (validate()) $el.requestSubmit()"
  hx-post="/api/subscribe"
  hx-target="#result"
  hx-swap="innerHTML">

  <input 
    type="email"
    name="email"
    x-model="email"
    @input="validate()"
    :class="{ 'border-green-500': isValid, 'border-red-500': email && !isValid }"
    class="border px-3 py-2 rounded">

  <button 
    type="submit"
    :disabled="!isValid"
    class="px-4 py-2 bg-blue-500 text-white rounded disabled:opacity-50">
    Subscribe
  </button>
</form>

<div id="result"></div>
```
