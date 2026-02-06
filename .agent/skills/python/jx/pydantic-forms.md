---
name: jx-pydantic-forms
description: Form handling in JX with FastAPI and Pydantic only (no Formidable), including submit, validation, field errors, HTMX flows, and JSON/form interoperability.
---

# Forms with Pydantic (FastAPI + JX + HTMX)

Use this guide when you want a single validation layer based on Pydantic for frontend form data.

## Documentation

- FastAPI Forms: <https://fastapi.tiangolo.com/tutorial/request-forms/>
- FastAPI `request.form()`: <https://fastapi.tiangolo.com/reference/request/>
- Pydantic Docs: <https://docs.pydantic.dev/latest/>
- Pydantic LLMs: <https://docs.pydantic.dev/latest/llms.txt>
- Pydantic Validation Errors: <https://docs.pydantic.dev/latest/errors/errors/>
- HTMX Docs: <https://htmx.org/docs/>

## Scope

- Parse and validate form payloads with Pydantic only
- Return JX partials for success and validation errors
- Support full submit and field-level validation
- Reuse the same schema for `application/x-www-form-urlencoded` and JSON

## Why Pydantic-only

- One schema contract for UI, API, and service layer
- Typed payloads (`EmailStr`, enums, strict fields)
- Consistent error model (`ValidationError`) and easier test coverage

## Dependencies

Install base dependencies:

```bash
uv add fastapi pydantic python-multipart
```

For email validation types:

```bash
uv add "pydantic[email]"
```

## Canonical Schema

```python
from pydantic import BaseModel, ConfigDict, EmailStr, Field, ValidationError, field_validator


class ContactFormIn(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    message: str = Field(min_length=10, max_length=2000)
    topic: str = Field(default="general")

    @field_validator("topic")
    @classmethod
    def validate_topic(cls, value: str) -> str:
        allowed = {"general", "sales", "support"}
        if value not in allowed:
            raise ValueError("Invalid topic")
        return value
```

## Validation Error Normalization

Normalize Pydantic errors to a field -> message map for template rendering:

```python
from pydantic import ValidationError


def errors_by_field(exc: ValidationError) -> dict[str, str]:
    errors: dict[str, str] = {}
    for err in exc.errors():
        loc = err.get("loc", ())
        field = str(loc[-1]) if loc else "_form"
        if field not in errors:
            errors[field] = err.get("msg", "Invalid value")
    return errors
```

## JX Form Component (HTMX submit)

```jinja
{#def values=None, errors=None #}
{% set values = values or {} %}
{% set errors = errors or {} %}

<form
  hx-post="/contact/submit"
  hx-target="#contact-form-container"
  hx-swap="outerHTML"
  class="space-y-4"
>
  <div>
    <label for="name">Name</label>
    <input id="name" name="name" value="{{ values.get('name', '') }}" />
    {% if errors.get("name") %}
      <p class="text-sm text-red-600">{{ errors["name"] }}</p>
    {% endif %}
  </div>

  <div>
    <label for="email">Email</label>
    <input
      id="email"
      type="email"
      name="email"
      value="{{ values.get('email', '') }}"
      hx-post="/contact/validate/email"
      hx-trigger="blur"
      hx-target="#email-error"
      hx-swap="innerHTML"
    />
    <p id="email-error" class="text-sm text-red-600">
      {{ errors.get("email", "") }}
    </p>
  </div>

  <div>
    <label for="topic">Topic</label>
    <select id="topic" name="topic">
      <option value="general" {% if values.get("topic") == "general" %}selected{% endif %}>General</option>
      <option value="sales" {% if values.get("topic") == "sales" %}selected{% endif %}>Sales</option>
      <option value="support" {% if values.get("topic") == "support" %}selected{% endif %}>Support</option>
    </select>
    {% if errors.get("topic") %}
      <p class="text-sm text-red-600">{{ errors["topic"] }}</p>
    {% endif %}
  </div>

  <div>
    <label for="message">Message</label>
    <textarea id="message" name="message">{{ values.get('message', '') }}</textarea>
    {% if errors.get("message") %}
      <p class="text-sm text-red-600">{{ errors["message"] }}</p>
    {% endif %}
  </div>

  <button type="submit">Send</button>
</form>
```

## FastAPI Endpoints (Form submit + partial response)

```python
from fastapi import APIRouter, Request
from fastapi.responses import HTMLResponse
from pydantic import ValidationError

router = APIRouter(tags=["web-contact"])


@router.get("/contact", response_class=HTMLResponse)
async def contact_page(request: Request) -> HTMLResponse:
    html = catalog.render("pages/Contact", request=request)
    return HTMLResponse(html)


@router.post("/contact/submit", response_class=HTMLResponse)
async def contact_submit(request: Request) -> HTMLResponse:
    form_data = await request.form()
    payload = dict(form_data)

    try:
        validated = ContactFormIn.model_validate(payload)
    except ValidationError as exc:
        html = catalog.render(
            "partials/ContactForm",
            request=request,
            values=payload,
            errors=errors_by_field(exc),
        )
        return HTMLResponse(html, status_code=400)

    await contact_service.send_message(validated)

    html = catalog.render(
        "partials/ContactSuccess",
        request=request,
        message="Message sent successfully.",
    )
    return HTMLResponse(html, status_code=200)
```

## Field-level Validation Endpoint

```python
from fastapi.responses import HTMLResponse
from pydantic import BaseModel, EmailStr, ValidationError


class EmailFieldCheck(BaseModel):
    email: EmailStr


@router.post("/contact/validate/email", response_class=HTMLResponse)
async def validate_email(request: Request) -> HTMLResponse:
    form_data = await request.form()
    candidate = {"email": form_data.get("email", "")}

    try:
        parsed = EmailFieldCheck.model_validate(candidate)
    except ValidationError:
        return HTMLResponse("Invalid email format", status_code=200)

    if await user_service.email_exists(parsed.email):
        return HTMLResponse("Email already in use", status_code=200)

    return HTMLResponse("", status_code=200)
```

## Reusing the Same Schema for JSON APIs

Use the same `ContactFormIn` schema in API routes:

```python
from fastapi import APIRouter

api = APIRouter(prefix="/api/v1/contact", tags=["api-contact"])


@api.post("")
async def api_contact_submit(payload: ContactFormIn) -> dict[str, str]:
    await contact_service.send_message(payload)
    return {"status": "ok"}
```

This keeps frontend form submit and API submit consistent.

## Optional: File Upload + Pydantic Metadata

Validate metadata with Pydantic and keep binary handling with FastAPI:

```python
from fastapi import File, Form, UploadFile
from pydantic import BaseModel, Field


class AvatarMeta(BaseModel):
    display_name: str = Field(min_length=2, max_length=80)


@router.post("/profile/avatar")
async def upload_avatar(
    display_name: str = Form(...),
    avatar: UploadFile = File(...),
):
    meta = AvatarMeta.model_validate({"display_name": display_name})
    # validate avatar.content_type/size before saving
    await profile_service.set_avatar(meta.display_name, avatar)
    return {"status": "ok"}
```

## Guardrails

- Keep all business validation server-side in Pydantic models.
- Return `400` with form partial for HTMX full-submit validation errors.
- Prefer one canonical input model per form use case.
- Use `extra="forbid"` to prevent silent unexpected fields.
- Do not duplicate validation logic between route handlers and services.
