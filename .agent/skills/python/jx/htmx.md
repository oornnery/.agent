---
name: jx-htmx
description: >
  HTMX patterns and reference for JX components. Use this skill when implementing
  HTMX-powered interactions like live search, infinite scroll, inline editing, polling,
  cascading selects, form validation, delete with confirmation, or out-of-band updates.
  Triggers include hx-get, hx-post, hx-target, hx-swap, hx-trigger, htmx attributes,
  AJAX interactions in Jinja templates, or HTMX response headers.
---

# HTMX Patterns Reference for JX

## Request Attributes

| Attribute   | Description           |
| ----------- | --------------------- |
| `hx-get`    | GET request to URL    |
| `hx-post`   | POST request to URL   |
| `hx-put`    | PUT request to URL    |
| `hx-patch`  | PATCH request to URL  |
| `hx-delete` | DELETE request to URL |

## Response Handling

| Attribute       | Description                        |
| --------------- | ---------------------------------- |
| `hx-target`     | CSS selector for element to swap   |
| `hx-swap`       | How to swap content                |
| `hx-select`     | CSS selector to pick from response |
| `hx-select-oob` | Out-of-band selections             |

## Swap Options

```html
hx-swap="innerHTML"         <!-- Replace inner HTML (default) -->
hx-swap="outerHTML"         <!-- Replace entire element -->
hx-swap="beforebegin"       <!-- Insert before element -->
hx-swap="afterbegin"        <!-- Insert at start of element -->
hx-swap="beforeend"         <!-- Insert at end of element -->
hx-swap="afterend"          <!-- Insert after element -->
hx-swap="delete"            <!-- Delete element -->
hx-swap="none"              <!-- No swap -->

<!-- With modifiers -->
hx-swap="innerHTML swap:1s"      <!-- Delay swap -->
hx-swap="innerHTML settle:500ms" <!-- Settle time for transitions -->
hx-swap="innerHTML show:top"     <!-- Scroll to top after swap -->
```

## Trigger Examples

```html
hx-trigger="click"                      <!-- Click (default for buttons) -->
hx-trigger="change"                     <!-- Change (default for inputs) -->
hx-trigger="submit"                     <!-- Form submit -->
hx-trigger="load"                       <!-- On element load -->
hx-trigger="revealed"                   <!-- When scrolled into view -->
hx-trigger="intersect"                  <!-- Intersection observer -->
hx-trigger="every 5s"                   <!-- Poll every 5 seconds -->
hx-trigger="keyup changed delay:300ms"  <!-- Debounced keyup -->
hx-trigger="keyup[key=='Enter']"        <!-- Specific key -->
hx-trigger="click from:body"            <!-- Event from another element -->
hx-trigger="custom-event from:body"     <!-- Custom event -->
```

## JX Component Patterns

### Live Search

```jinja
{# components/features/live-search.jinja #}
{#def endpoint, placeholder="Search...", min_chars=2 #}

<div class="relative">
  <input 
    type="search"
    name="q"
    hx-get="{{ endpoint }}"
    hx-trigger="input changed delay:300ms[target.value.length >= {{ min_chars }}], search"
    hx-target="#search-results"
    hx-indicator="#search-spinner"
    placeholder="{{ placeholder }}"
    class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500">

  <div id="search-spinner" class="htmx-indicator absolute right-3 top-1/2 -translate-y-1/2">
    <svg class="animate-spin h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
    </svg>
  </div>
</div>

<div id="search-results" class="mt-4"></div>
```

### Infinite Scroll

```jinja
{# components/features/infinite-scroll.jinja #}
{#def items, endpoint, page, has_more=True #}

{% for item in items %}
  <div class="p-4 border-b">
    {{ item.title }}
  </div>
{% endfor %}

{% if has_more %}
  <div 
    hx-get="{{ endpoint }}?page={{ page + 1 }}"
    hx-trigger="revealed"
    hx-swap="outerHTML"
    class="p-4 text-center text-gray-500">
    <span class="htmx-indicator">Loading...</span>
  </div>
{% endif %}
```

### Inline Edit

```jinja
{# components/features/inline-edit.jinja #}
{#def id, field, value, endpoint #}

<div 
  id="field-{{ id }}"
  hx-get="{{ endpoint }}/{{ id }}/edit"
  hx-trigger="click"
  hx-swap="outerHTML"
  class="p-2 rounded cursor-pointer hover:bg-gray-100 transition-colors">
  {{ value or "Click to edit" }}
</div>
```

```jinja
{# components/features/inline-edit-form.jinja #}
{#def id, field, value, endpoint #}

<form 
  id="field-{{ id }}"
  hx-put="{{ endpoint }}/{{ id }}"
  hx-swap="outerHTML"
  hx-target="this"
  class="flex gap-2">
  <input 
    type="text" 
    name="{{ field }}" 
    value="{{ value }}"
    class="flex-1 border rounded px-2 py-1"
    autofocus>
  <button type="submit" class="px-3 py-1 bg-blue-500 text-white rounded">Save</button>
  <button 
    type="button"
    hx-get="{{ endpoint }}/{{ id }}"
    hx-target="#field-{{ id }}"
    hx-swap="outerHTML"
    class="px-3 py-1 bg-gray-200 rounded">Cancel</button>
</form>
```

### Delete with Confirmation

```jinja
{# components/features/delete-button.jinja #}
{#def endpoint, id, confirm_message="Are you sure?" #}

<button 
  hx-delete="{{ endpoint }}/{{ id }}"
  hx-confirm="{{ confirm_message }}"
  hx-target="closest .item-row"
  hx-swap="outerHTML swap:500ms"
  class="px-3 py-1 bg-red-500 text-white rounded hover:bg-red-600">
  Delete
</button>
```

### Form with Validation

```jinja
{# components/features/ajax-form.jinja #}
{#def endpoint, method="post" #}

<form 
  hx-{{ method }}="{{ endpoint }}"
  hx-target="#form-response"
  hx-swap="innerHTML"
  hx-indicator="#form-spinner">

  {{ content }}

  <div class="flex items-center gap-4 mt-4">
    <button type="submit" class="px-4 py-2 bg-blue-500 text-white rounded">
      Submit
    </button>
    <span id="form-spinner" class="htmx-indicator">Processing...</span>
  </div>
</form>

<div id="form-response"></div>
```

### Cascading Selects

```jinja
{# components/features/country-select.jinja #}
{#def countries, states_endpoint #}

<select 
  name="country"
  hx-get="{{ states_endpoint }}"
  hx-target="#state-select"
  hx-trigger="change"
  class="border rounded px-3 py-2">
  <option value="">Select Country</option>
  {% for country in countries %}
    <option value="{{ country.id }}">{{ country.name }}</option>
  {% endfor %}
</select>

<select 
  id="state-select"
  name="state"
  class="border rounded px-3 py-2"
  disabled>
  <option value="">Select country first</option>
</select>
```

### Polling

```jinja
{# components/features/live-status.jinja #}
{#def endpoint, interval="5s" #}

<div 
  hx-get="{{ endpoint }}"
  hx-trigger="load, every {{ interval }}"
  hx-swap="innerHTML"
  class="p-4 bg-gray-50 rounded">
  Loading status...
</div>
```

### Out-of-Band Updates

Server can update multiple elements:

```html
<!-- Main response -->
<div id="main-content">Updated content</div>

<!-- Out-of-band updates -->
<span id="notification-count" hx-swap-oob="true">5</span>
<div id="flash-messages" hx-swap-oob="true">
  <div class="alert alert-success">Item saved!</div>
</div>
```

## Request Headers

HTMX sends these headers automatically:

| Header           | Value                   |
| ---------------- | ----------------------- |
| `HX-Request`     | "true"                  |
| `HX-Target`      | ID of target element    |
| `HX-Trigger`     | ID of triggered element |
| `HX-Current-URL` | Current URL             |

### Checking for HTMX in Python

```python
# Flask
def is_htmx_request():
    return request.headers.get('HX-Request') == 'true'

# FastAPI
def is_htmx_request(request: Request):
    return request.headers.get('hx-request') == 'true'
```

## Response Headers

Server can send these to control client behavior:

| Header           | Effect               |
| ---------------- | -------------------- |
| `HX-Redirect`    | Client-side redirect |
| `HX-Refresh`     | Full page refresh    |
| `HX-Trigger`     | Trigger client event |
| `HX-Push-Url`    | Push URL to history  |
| `HX-Replace-Url` | Replace current URL  |

### Example: Trigger Toast After Action

```python
@app.route("/api/save", methods=["POST"])
def save():
    # ... save logic ...
    response = make_response(catalog.render("partials/success.jinja"))
    response.headers["HX-Trigger"] = json.dumps({
        "showToast": {"type": "success", "message": "Saved!"}
    })
    return response
```

## Events

Listen to HTMX events in JavaScript or Alpine:

```javascript
// JavaScript
document.body.addEventListener('htmx:beforeRequest', (e) => {
  console.log('Request starting:', e.detail);
});

document.body.addEventListener('htmx:afterSwap', (e) => {
  console.log('Content swapped:', e.detail);
});
```

```jinja
{# Alpine integration #}
<div 
  x-data="{ loading: false }"
  @htmx:before-request="loading = true"
  @htmx:after-request="loading = false">
  <span x-show="loading">Loading...</span>
</div>
```

## CSS Classes

HTMX adds these classes automatically:

| Class            | When Applied          |
| ---------------- | --------------------- |
| `.htmx-request`  | During active request |
| `.htmx-settling` | During settle phase   |
| `.htmx-swapping` | During swap phase     |
| `.htmx-added`    | Newly added elements  |

### Indicator Pattern

```css
.htmx-indicator {
  display: none;
}

.htmx-request .htmx-indicator {
  display: inline;
}

.htmx-request.htmx-indicator {
  display: inline;
}
```
