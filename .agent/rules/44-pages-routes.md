---
name: pages-routes
description: Page structure and FastAPI routing patterns. Use when creating new pages, routes, or understanding app navigation.
---

# Pages & Routes

## Public Pages

| Route              | Page              | Description           |
|--------------------|-------------------|-----------------------|
| `/`                | Home              | Landing page          |
| `/about`           | About             | About page            |
| `/projects`        | Projects          | Projects list         |
| `/projects/{id}`   | ProjectDetail     | Single project        |
| `/blog`            | Blog              | Blog posts list       |
| `/blog/{slug}`     | PostDetail        | Single blog post      |
| `/contact`         | Contact           | Contact form          |

## Admin Pages (authenticated)

| Route                | Page                | Description           |
|----------------------|---------------------|-----------------------|
| `/admin`             | Dashboard           | Admin overview        |
| `/admin/blog`        | BlogAdmin           | Manage posts          |
| `/admin/blog/new`    | PostEditor          | Create post           |
| `/admin/blog/{id}`   | PostEditor          | Edit post             |
| `/admin/projects`    | ProjectsAdmin       | Manage projects       |
| `/admin/projects/new`| ProjectEditor       | Create project        |
| `/admin/projects/{id}`| ProjectEditor      | Edit project          |
| `/admin/profile`     | ProfileAdmin        | Edit profile          |
| `/admin/analytics`   | Analytics           | View analytics        |

---

## FastAPI Router Structure

### Public views (app/views/public.py)

```python
from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse

router = APIRouter()

@router.get("/", response_class=HTMLResponse)
async def home(request: Request) -> HTMLResponse:
    return catalog.render("pages/Home", request=request)

@router.get("/about", response_class=HTMLResponse)
async def about(request: Request) -> HTMLResponse:
    return catalog.render("pages/About", request=request)

@router.get("/projects", response_class=HTMLResponse)
async def projects(request: Request) -> HTMLResponse:
    projects = await project_service.list_published()
    return catalog.render("pages/Projects", request=request, projects=projects)

@router.get("/projects/{id}", response_class=HTMLResponse)
async def project_detail(request: Request, id: int) -> HTMLResponse:
    project = await project_service.get_by_id(id)
    if not project:
        raise HTTPException(404)
    return catalog.render("pages/ProjectDetail", request=request, project=project)

@router.get("/blog", response_class=HTMLResponse)
async def blog(request: Request) -> HTMLResponse:
    posts = await post_service.list_published()
    return catalog.render("pages/Blog", request=request, posts=posts)

@router.get("/blog/{slug}", response_class=HTMLResponse)
async def post_detail(request: Request, slug: str) -> HTMLResponse:
    post = await post_service.get_by_slug(slug)
    if not post:
        raise HTTPException(404)
    return catalog.render("pages/PostDetail", request=request, post=post)

@router.get("/contact", response_class=HTMLResponse)
async def contact(request: Request) -> HTMLResponse:
    form = ContactForm()
    return catalog.render("pages/Contact", request=request, form=form)
```

### Admin views (app/views/admin.py)

```python
from fastapi import APIRouter, Request, Depends
from fastapi.responses import HTMLResponse
from app.core.auth import require_auth

router = APIRouter(prefix="/admin", dependencies=[Depends(require_auth)])

@router.get("/", response_class=HTMLResponse)
async def dashboard(request: Request) -> HTMLResponse:
    stats = await analytics_service.get_dashboard_stats()
    return catalog.render("admin/Dashboard", request=request, stats=stats)

@router.get("/blog", response_class=HTMLResponse)
async def blog_admin(request: Request) -> HTMLResponse:
    posts = await post_service.list_all()
    return catalog.render("admin/BlogAdmin", request=request, posts=posts)

@router.get("/blog/new", response_class=HTMLResponse)
async def post_new(request: Request) -> HTMLResponse:
    form = PostForm()
    return catalog.render("admin/PostEditor", request=request, form=form)

@router.get("/blog/{id}", response_class=HTMLResponse)
async def post_edit(request: Request, id: int) -> HTMLResponse:
    post = await post_service.get_by_id(id)
    if not post:
        raise HTTPException(404)
    form = PostForm(obj=post)
    return catalog.render("admin/PostEditor", request=request, form=form, post=post)
```

---

## Page Components (Jx)

### Layout structure

```text
components/
  layouts/
    Base.jinja       # HTML boilerplate, head, scripts
    Public.jinja     # Navbar + footer for public pages
    Admin.jinja      # Sidebar + topbar for admin
    Home.jinja       # Special home layout (no navbar)
  pages/
    Home.jinja
    About.jinja
    Projects.jinja
    ProjectDetail.jinja
    Blog.jinja
    PostDetail.jinja
    Contact.jinja
  admin/
    Dashboard.jinja
    BlogAdmin.jinja
    PostEditor.jinja
    ProjectsAdmin.jinja
    ProjectEditor.jinja
```

### Base layout

```jinja
{#def title, description="" #}
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{{ title }}</title>
    <meta name="description" content="{{ description }}" />

    <script src="https://unpkg.com/htmx.org@2.0.4"></script>
    {{ assets.render_css() }}
  </head>
  <body class="min-h-dvh bg-[var(--bg)] text-[var(--text)]">
    {{ content }}
    {{ assets.render_js() }}
  </body>
</html>
```

### Public layout

```jinja
{#def title, description="", current_path="/" #}
<Base title="{{ title }}" description="{{ description }}">
  <Navbar current_path="{{ current_path }}" />
  <main class="mx-auto max-w-5xl px-6 py-12">
    {{ content }}
  </main>
  <Footer />
</Base>
```

### Page example (Projects)

```jinja
{#def projects #}
<Public title="Projects" current_path="/projects">
  <header class="mb-12">
    <h1 class="h1 mb-4">Projects</h1>
    <p class="text-[var(--text-2)]">Things I've built and worked on.</p>
  </header>

  {% if projects %}
    <div class="grid gap-6 md:grid-cols-2">
      {% for project in projects %}
        <Card
          title="{{ project.title }}"
          href="/projects/{{ project.id }}"
          image="{{ project.image_url }}"
          class="enter stagger-{{ loop.index }}"
        >
          {{ project.summary }}
          <div class="mt-3 flex flex-wrap gap-2">
            {% for tag in project.tags %}
              <Tag>{{ tag }}</Tag>
            {% endfor %}
          </div>
        </Card>
      {% endfor %}
    </div>
  {% else %}
    <EmptyState
      icon="search"
      title="No projects yet"
      description="Check back soon!"
    />
  {% endif %}
</Public>
```
