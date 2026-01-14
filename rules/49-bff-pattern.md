---
name: bff-pattern
description: Backend for Frontend pattern for API aggregation. Use when combining multiple backend services for frontend consumption.
---

# BFF (Backend for Frontend) Pattern

BFF acts as middleware between frontend and multiple backend services.

## When to use BFF

- Aggregate data from multiple APIs
- Transform/filter responses for specific frontend needs
- Handle auth/sessions in one place
- Reduce frontend complexity

---

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌──────────────┐
│   Browser   │────▶│     BFF     │────▶│  Service A   │
│  (HTMX)     │     │  (FastAPI)  │────▶│  Service B   │
└─────────────┘     └─────────────┘     │  External    │
                                        └──────────────┘
```

---

## BFF Service Example

```python
# app/bff/services.py
import httpx
from app.config import settings

class BFFService:
    def __init__(self):
        self.client = httpx.AsyncClient(timeout=10.0)

    async def get_dashboard_data(self, user_id: int) -> dict:
        """Aggregate data from multiple services."""
        async with self.client as client:
            # Parallel requests
            user_task = client.get(f"{settings.USER_SERVICE}/users/{user_id}")
            posts_task = client.get(f"{settings.BLOG_SERVICE}/posts?author={user_id}")
            stats_task = client.get(f"{settings.ANALYTICS_SERVICE}/stats/{user_id}")

            user_resp, posts_resp, stats_resp = await asyncio.gather(
                user_task, posts_task, stats_task
            )

        return {
            "user": user_resp.json(),
            "recent_posts": posts_resp.json()[:5],
            "stats": stats_resp.json()
        }

    async def get_project_with_comments(self, project_id: int) -> dict:
        """Combine project data with comments."""
        async with self.client as client:
            project = await client.get(f"{settings.PROJECT_SERVICE}/projects/{project_id}")
            comments = await client.get(f"{settings.COMMENT_SERVICE}/comments?project={project_id}")

        return {
            "project": project.json(),
            "comments": comments.json()
        }

bff_service = BFFService()
```

---

## BFF Router

```python
# app/api/v1/bff.py
from fastapi import APIRouter, Depends
from app.bff.services import bff_service
from app.core.auth import get_current_user

router = APIRouter(prefix="/bff", tags=["bff"])

@router.get("/dashboard")
async def dashboard(user = Depends(get_current_user)):
    return await bff_service.get_dashboard_data(user.id)

@router.get("/projects/{id}/full")
async def project_full(id: int):
    return await bff_service.get_project_with_comments(id)
```

---

## BFF with HTMX (HTML responses)

```python
@router.get("/dashboard", response_class=HTMLResponse)
async def dashboard_html(request: Request, user = Depends(get_current_user)):
    data = await bff_service.get_dashboard_data(user.id)
    return catalog.render("admin/Dashboard", **data, request=request)

@router.get("/projects/{id}/card", response_class=HTMLResponse)
async def project_card(request: Request, id: int):
    data = await bff_service.get_project_with_comments(id)
    return catalog.render("projects/ProjectCard", **data)
```

---

## Error handling

```python
class BFFService:
    async def safe_request(self, url: str) -> dict | None:
        try:
            async with httpx.AsyncClient() as client:
                resp = await client.get(url, timeout=5.0)
                resp.raise_for_status()
                return resp.json()
        except httpx.HTTPError:
            return None

    async def get_dashboard_data(self, user_id: int) -> dict:
        user = await self.safe_request(f"{USER_SERVICE}/users/{user_id}")
        posts = await self.safe_request(f"{BLOG_SERVICE}/posts?author={user_id}") or []

        return {"user": user, "recent_posts": posts[:5]}
```
