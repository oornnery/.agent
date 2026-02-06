---
name: api-endpoints
description: REST API structure and FastAPI endpoint patterns. Use when creating or modifying API endpoints.
---

# API Endpoints

## Public API

| Method | Endpoint                       | Description            |
|--------|--------------------------------|------------------------|
| GET    | `/api/v1/posts`                | List published posts   |
| GET    | `/api/v1/posts/{slug}`         | Get post by slug       |
| POST   | `/api/v1/posts/{id}/reactions` | Add reaction to post   |
| GET    | `/api/v1/projects`             | List published projects|
| GET    | `/api/v1/projects/{id}`        | Get project by ID      |
| POST   | `/api/v1/contact`              | Submit contact form    |
| GET    | `/api/v1/comments/{post_id}`   | List comments for post |
| POST   | `/api/v1/comments`             | Add comment            |

## Auth API

| Method | Endpoint              | Description           |
|--------|-----------------------|-----------------------|
| POST   | `/api/v1/auth/login`  | Login with credentials|
| POST   | `/api/v1/auth/logout` | Logout (clear cookie) |
| GET    | `/api/v1/auth/me`     | Get current user      |
| GET    | `/api/v1/auth/github` | OAuth with GitHub     |

## Admin API (authenticated)

| Method | Endpoint                 | Description         |
|--------|--------------------------|---------------------|
| GET    | `/api/v1/posts`          | List all posts      |
| POST   | `/api/v1/posts`          | Create post         |
| PUT    | `/api/v1/posts/{id}`     | Update post         |
| DELETE | `/api/v1/posts/{id}`     | Delete post         |
| GET    | `/api/v1/projects`       | List all projects   |
| POST   | `/api/v1/projects`       | Create project      |
| PUT    | `/api/v1/projects/{id}`  | Update project      |
| DELETE | `/api/v1/projects/{id}`  | Delete project      |
| GET    | `/api/v1/analytics`      | Get analytics data  |

---

## FastAPI Implementation

### Router structure

```text
app/
  api/
    v1/
      __init__.py
      endpoints/
        auth.py
        blog.py
        comments.py
        contact.py
        projects.py
        analytics.py
```

### API router (api/v1/__init__.py)

```python
from fastapi import APIRouter

from app.api.v1.endpoints import auth, blog, comments, contact, projects, analytics

api_router = APIRouter(prefix="/api/v1")

api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(blog.router, prefix="/posts", tags=["blog"])
api_router.include_router(comments.router, prefix="/comments", tags=["comments"])
api_router.include_router(contact.router, prefix="/contact", tags=["contact"])
api_router.include_router(projects.router, prefix="/projects", tags=["projects"])
api_router.include_router(analytics.router, prefix="/analytics", tags=["analytics"])
```

### Blog endpoints (api/v1/endpoints/blog.py)

```python
from fastapi import APIRouter, Depends, HTTPException, status
from app.core.auth import get_current_user, require_auth
from app.models.blog import Post, PostCreate, PostUpdate
from app.services.blog import post_service

router = APIRouter()

# Public endpoints
@router.get("/", response_model=list[Post])
async def list_posts(skip: int = 0, limit: int = 20):
    return await post_service.list_published(skip=skip, limit=limit)

@router.get("/{slug}", response_model=Post)
async def get_post(slug: str):
    post = await post_service.get_by_slug(slug)
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    return post

@router.post("/{id}/reactions")
async def add_reaction(id: int, reaction: str):
    return await post_service.add_reaction(id, reaction)

# Admin endpoints
@router.post("/", response_model=Post, dependencies=[Depends(require_auth)])
async def create_post(data: PostCreate):
    return await post_service.create(data)

@router.put("/{id}", response_model=Post, dependencies=[Depends(require_auth)])
async def update_post(id: int, data: PostUpdate):
    post = await post_service.update(id, data)
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    return post

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(require_auth)])
async def delete_post(id: int):
    deleted = await post_service.delete(id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Post not found")
```

### Contact endpoint (api/v1/endpoints/contact.py)

```python
from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse
from pydantic import BaseModel, EmailStr

from app.forms.contact import ContactForm
from app.services.email import send_contact_email

router = APIRouter()

class ContactRequest(BaseModel):
    name: str
    email: EmailStr
    message: str

# JSON API
@router.post("/")
async def submit_contact_json(data: ContactRequest):
    await send_contact_email(data.name, data.email, data.message)
    return {"status": "sent"}

# HTMX endpoint (returns HTML fragment)
@router.post("/form", response_class=HTMLResponse)
async def submit_contact_form(request: Request):
    form = ContactForm.from_request(request)

    if not form.is_valid():
        return HTMLResponse(
            catalog.render("partials/ContactForm", form=form),
            status_code=400
        )

    await send_contact_email(form.data["name"], form.data["email"], form.data["message"])

    return HTMLResponse(
        '<p class="text-[var(--accent-2)]">✓ Message sent successfully!</p>'
    )
```

### Auth endpoints (api/v1/endpoints/auth.py)

```python
from fastapi import APIRouter, Depends, HTTPException, Response, Request
from fastapi.responses import RedirectResponse
from pydantic import BaseModel

from app.core.auth import create_access_token, verify_password, get_current_user
from app.models.user import User
from app.services.user import user_service

router = APIRouter()

class LoginRequest(BaseModel):
    email: str
    password: str

@router.post("/login")
async def login(data: LoginRequest, response: Response):
    user = await user_service.get_by_email(data.email)
    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    token = create_access_token({"sub": str(user.id)})
    response.set_cookie(
        key="access_token",
        value=token,
        httponly=True,
        secure=True,
        samesite="lax",
        max_age=60 * 60 * 24 * 7  # 7 days
    )
    return {"status": "logged_in"}

@router.post("/logout")
async def logout(response: Response):
    response.delete_cookie("access_token")
    return {"status": "logged_out"}

@router.get("/me", response_model=User)
async def get_me(user: User = Depends(get_current_user)):
    return user

@router.get("/github")
async def github_oauth(request: Request):
    # Redirect to GitHub OAuth
    ...
```

---

## Pydantic Models

```python
from datetime import datetime
from pydantic import BaseModel, EmailStr

class PostBase(BaseModel):
    title: str
    slug: str
    content: str
    summary: str | None = None
    published: bool = False

class PostCreate(PostBase):
    pass

class PostUpdate(BaseModel):
    title: str | None = None
    slug: str | None = None
    content: str | None = None
    summary: str | None = None
    published: bool | None = None

class Post(PostBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
```
