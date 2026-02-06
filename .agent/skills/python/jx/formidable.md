---
name: forms-formidable
description: Form handling with Formidable and HTMX validation. Use when creating forms, handling validation, or implementing field-level feedback.
---

# Forms (Formidable + HTMX)

Pattern:

- Server validates
- Return partial with errors OR success fragment
- Use `hx-post` / `hx-trigger="blur"` for field-level validation

## Documentation

- Formidable: <https://github.com/jpsca/formidable>
- HTMX Docs: <https://htmx.org/docs/>
- FastAPI Forms: <https://fastapi.tiangolo.com/tutorial/request-forms/>

---

## Form Definition

```python
from formidable import Form
from formidable.fields import Text, Email, Textarea, Password, Select

class ContactForm(Form):
    name = Text(required=True, min_length=2, max_length=100)
    email = Email(required=True)
    message = Textarea(required=True, min_length=10)

class LoginForm(Form):
    email = Email(required=True)
    password = Password(required=True, min_length=8)

class PostForm(Form):
    title = Text(required=True, max_length=200)
    slug = Text(required=True, pattern=r"^[a-z0-9-]+$")
    content = Textarea(required=True)
    status = Select(choices=[("draft", "Draft"), ("published", "Published")])
```

---

## Form Template (HTMX)

```jinja
{#def form #}
<form
  hx-post="/api/v1/contact"
  hx-target="#form-result"
  hx-swap="innerHTML"
  class="space-y-4"
>
  <Input name="name" label="Name" value="{{ form.name.value }}" error="{{ form.name.error }}" required />
  <Input name="email" type="email" label="Email" value="{{ form.email.value }}" error="{{ form.email.error }}" required />
  <Input name="message" type="textarea" label="Message" value="{{ form.message.value }}" error="{{ form.message.error }}" required />

  <Button type="submit" variant="primary">Send Message</Button>
</form>
<div id="form-result" class="mt-4"></div>
```

---

## FastAPI Endpoint

```python
from fastapi import Request
from fastapi.responses import HTMLResponse

@router.post("/contact", response_class=HTMLResponse)
async def submit_contact(request: Request):
    form_data = await request.form()
    form = ContactForm(form_data)

    if not form.is_valid():
        return HTMLResponse(
            catalog.render("partials/ContactForm", form=form),
            status_code=400
        )

    await email_service.send_contact(
        name=form.data["name"],
        email=form.data["email"],
        message=form.data["message"]
    )

    return HTMLResponse(
        '<p class="text-[var(--accent-2)]">&#10003; Message sent!</p>'
    )
```

---

## Field-level validation (blur)

```jinja
<input
  name="email"
  type="email"
  hx-post="/api/v1/validate/email"
  hx-trigger="blur"
  hx-target="#email-error"
  hx-swap="innerHTML"
/>
<span id="email-error" class="text-sm text-[var(--danger)]"></span>
```

```python
@router.post("/validate/email", response_class=HTMLResponse)
async def validate_email(request: Request):
    form_data = await request.form()
    email = form_data.get("email", "")

    if not email or "@" not in email:
        return HTMLResponse("Invalid email address")

    if await user_service.email_exists(email):
        return HTMLResponse("Email already registered")

    return HTMLResponse("")  # Valid
```
