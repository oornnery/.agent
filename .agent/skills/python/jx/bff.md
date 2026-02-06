---
name: jx-bff
description: JX-oriented BFF patterns for HTML-first rendering, HTMX partials, and Pydantic-validated form workflows.
---

# BFF for JX (HTML-First)

Use this pattern when JX pages need aggregated data from multiple services and server-driven UI updates.

## Why BFF in JX

In JX projects, the BFF is not only an API aggregator. It is also the place where:

- UI-specific view models are assembled
- JX partials/pages are rendered
- HTMX interactions return targeted HTML fragments
- form inputs are validated with Pydantic before hitting domain services

## Request Flow

```text
Browser (JX + HTMX)
  -> FastAPI BFF endpoint
  -> service aggregation (internal APIs, DB, external APIs)
  -> view-model shaping
  -> catalog.render(...) page/partial
  -> HTML fragment or full page
```

## JX-Focused Rules

- Prefer HTML responses for HTMX interactions.
- Keep JSON responses only for explicit API clients.
- Build explicit view models (do not pass raw service payloads directly to templates).
- Keep endpoint handlers thin; move aggregation to service layer.
- Validate form data server-side with Pydantic (`model_validate`).

## Recommended Structure

```text
app/
  bff/
    service.py
    schemas.py
  web/
    routes/
      dashboard.py
      contact.py
  components/
    pages/
      Dashboard.jinja
    partials/
      ContactForm.jinja
      ContactSuccess.jinja
      FormErrors.jinja
```

## Pydantic Contracts (Input + View Models)

```python
# app/bff/schemas.py
from pydantic import BaseModel, ConfigDict, EmailStr, Field

class DashboardVM(BaseModel):
    model_config = ConfigDict(extra="forbid")

    user_name: str
    post_count: int
    recent_posts: list[dict]
    unread_notifications: int

class ContactFormInput(BaseModel):
    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
    )

    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    message: str = Field(min_length=10, max_length=2000)
```

## Aggregation Service Example

```python
# app/bff/service.py
import asyncio
import httpx
from app.bff.schemas import DashboardVM

class BFFService:
    def __init__(self, client: httpx.AsyncClient) -> None:
        self.client = client

    async def get_dashboard_vm(self, user_id: int) -> DashboardVM:
        user_task = self.client.get(f"http://user-svc/users/{user_id}")
        posts_task = self.client.get(f"http://blog-svc/posts?author={user_id}&limit=5")
        notifications_task = self.client.get(f"http://notify-svc/unread/{user_id}")

        user_resp, posts_resp, notify_resp = await asyncio.gather(
            user_task,
            posts_task,
            notifications_task,
        )

        user_resp.raise_for_status()
        posts_resp.raise_for_status()
        notify_resp.raise_for_status()

        user = user_resp.json()
        posts = posts_resp.json()
        notify = notify_resp.json()

        return DashboardVM(
            user_name=user["name"],
            post_count=len(posts),
            recent_posts=posts,
            unread_notifications=notify["count"],
        )
```

## Full Page Render (JX)

```python
from fastapi import APIRouter, Depends, Request
from fastapi.responses import HTMLResponse

router = APIRouter(prefix="/dashboard", tags=["dashboard"])

@router.get("/", response_class=HTMLResponse)
async def dashboard_page(request: Request, user=Depends(get_current_user)):
    vm = await bff_service.get_dashboard_vm(user.id)
    return catalog.render("pages/Dashboard", request=request, vm=vm)
```

## HTMX Partial Render

For incremental updates, return partials instead of full pages.

```python
@router.get("/summary", response_class=HTMLResponse)
async def dashboard_summary(request: Request, user=Depends(get_current_user)):
    vm = await bff_service.get_dashboard_vm(user.id)
    return catalog.render("partials/DashboardSummary", request=request, vm=vm)
```

Client-side trigger:

```jinja
<div
  hx-get="/dashboard/summary"
  hx-trigger="load, every 20s"
  hx-target="#dashboard-summary"
  hx-swap="innerHTML">
</div>
<div id="dashboard-summary"></div>
```

## Pydantic Form Validation (HTMX Submit)

### JX Form Component

```jinja
{#def values=None, errors=None #}
<form
  hx-post="/contact/submit"
  hx-target="#contact-result"
  hx-swap="innerHTML"
  class="space-y-3">

  <Input name="name" value="{{ values.name if values else '' }}" error="{{ errors.name if errors else '' }}" />
  <Input name="email" type="email" value="{{ values.email if values else '' }}" error="{{ errors.email if errors else '' }}" />
  <Input name="message" type="textarea" value="{{ values.message if values else '' }}" error="{{ errors.message if errors else '' }}" />

  <Button type="submit" variant="primary">Send</Button>
</form>
<div id="contact-result"></div>
```

### FastAPI Endpoint with Pydantic Validation

```python
from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse
from pydantic import ValidationError
from app.bff.schemas import ContactFormInput

router = APIRouter(prefix="/contact", tags=["contact"])

def pydantic_errors_to_dict(exc: ValidationError) -> dict[str, str]:
    out: dict[str, str] = {}
    for e in exc.errors():
        field = str(e["loc"][-1])
        out[field] = e["msg"]
    return out

@router.post("/submit", response_class=HTMLResponse)
async def contact_submit(request: Request):
    form_data = await request.form()
    payload = {k: v for k, v in form_data.items()}

    try:
        validated = ContactFormInput.model_validate(payload)
    except ValidationError as exc:
        errors = pydantic_errors_to_dict(exc)
        return HTMLResponse(
            catalog.render(
                "partials/ContactForm",
                request=request,
                values=payload,
                errors=errors,
            ),
            status_code=400,
        )

    await contact_service.send_message(
        name=validated.name,
        email=validated.email,
        message=validated.message,
    )

    return HTMLResponse(
        catalog.render("partials/ContactSuccess", request=request),
        status_code=200,
    )
```

## Field-Level Validation Endpoint (Optional)

Useful for `hx-trigger="blur"` checks.

```python
from pydantic import BaseModel, EmailStr, ValidationError

class EmailCheckInput(BaseModel):
    email: EmailStr

@router.post("/validate/email", response_class=HTMLResponse)
async def validate_email_field(request: Request):
    form_data = await request.form()
    payload = {"email": form_data.get("email", "")}

    try:
        data = EmailCheckInput.model_validate(payload)
    except ValidationError:
        return HTMLResponse("Invalid email format", status_code=400)

    if await user_service.email_exists(str(data.email)):
        return HTMLResponse("Email already registered", status_code=400)

    return HTMLResponse("")
```

Client input:

```jinja
<input
  name="email"
  type="email"
  hx-post="/contact/validate/email"
  hx-trigger="blur"
  hx-target="#email-error"
  hx-swap="innerHTML" />
<span id="email-error" class="text-sm text-[var(--danger)]"></span>
```

## Outbound Validation for Upstream Payloads

If upstream services are unstable, validate their responses before rendering:

```python
from pydantic import BaseModel

class UpstreamPost(BaseModel):
    id: int
    title: str
    summary: str | None = None

posts = [UpstreamPost.model_validate(x) for x in posts_resp.json()]
```

This prevents malformed payloads from breaking templates.

## Error and Fallback Strategy

- On upstream timeout/error, return partial fallback UI, not raw traceback.
- Keep per-widget fallback fragments (`partials/WidgetError`).
- For HTMX requests, return targeted HTML and proper status (`400/422/500`).
- Log correlation IDs for cross-service traces.

## Guardrails

- Do not mix raw upstream JSON directly into JX components.
- Keep BFF view models explicit and typed.
- Keep validation server-side even when Alpine/HTMX does client hints.
- Keep full-page and partial endpoints explicit (avoid ambiguous response type).
