---
name: jx-init-project
description: >
  JX project scaffolding reference. Use this skill when initializing a new JX project,
  creating the base directory structure, or setting up a Flask/FastAPI app with JX components.
  Triggers include creating a new JX app, scaffolding project structure, or setting up
  components directory with layout, ui, features, and pages folders.
---

# JX Project Initialization

## Project Structure

```
project/
├── app.py or main.py      # App entry point
├── requirements.txt        # Dependencies
├── components/
│   ├── layout/
│   │   ├── base.jinja      # Base HTML layout
│   │   └── header.jinja    # Header/nav
│   ├── ui/
│   │   ├── button.jinja    # Reusable UI components
│   │   └── card.jinja
│   ├── features/
│   │   ├── live-search.jinja
│   │   └── search-results.jinja
│   └── pages/
│       └── home.jinja      # Full page components
└── static/                  # Static assets
```

## Flask Setup

```python
from flask import Flask, request
from jx import Catalog

app = Flask(__name__)
catalog = Catalog("components/")
catalog.jinja_env.globals.update(app.jinja_env.globals)

@app.route("/")
def index():
    return catalog.render("pages/home.jinja", products=get_products())
```

**Dependencies:** `flask>=3.0`, `jx`, `python-dotenv`

## FastAPI Setup

```python
from fastapi import FastAPI, Query
from fastapi.responses import HTMLResponse, StreamingResponse
from jx import Catalog

app = FastAPI()
catalog = Catalog("components/")

@app.get("/", response_class=HTMLResponse)
async def index():
    return catalog.render("pages/home.jinja", products=await get_products())
```

**Dependencies:** `fastapi>=0.110`, `uvicorn[standard]`, `jx`

## Base Layout Template

```jinja
{#def title="JX App" #}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/htmx.org@2.0.0"></script>
    <script src="https://unpkg.com/htmx-ext-sse@2.2.2/sse.js"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        .htmx-indicator { display: none; }
        .htmx-request .htmx-indicator { display: inline; }
        .htmx-request.htmx-indicator { display: inline; }
    </style>
</head>
<body class="min-h-screen bg-gray-50">
    {{ content }}
</body>
</html>
```

## Scaffold Script

Available at `jx/scripts/init_project.py`:

```bash
python jx/scripts/init_project.py <project-name> --framework flask|fastapi
```
