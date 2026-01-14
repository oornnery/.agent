---
name: security
description: Security headers, JWT auth, HTMX validation, and input validation. Use when implementing authentication or security features.
---

# Security Features

## Summary

| Feature          | Description                                      |
|------------------|--------------------------------------------------|
| OWASP Headers    | X-Content-Type-Options, X-Frame-Options, X-XSS  |
| CSP              | Content Security Policy (strict in production)  |
| CORS             | Configurable allowed origins                     |
| HTTPS Redirect   | Automatic redirect in production                 |
| JWT Auth         | Secure cookie-based authentication               |
| Rate Limiting    | slowapi with per-endpoint limits                 |
| HTMX Validation  | Origin validation for HTMX requests              |
| Input Validation | Pydantic models for all inputs                   |

---

## Security Headers Middleware

```python
from starlette.middleware.base import BaseHTTPMiddleware

class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
        return response
```

---

## JWT Auth (cookie-based)

```python
from jose import jwt
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_access_token(data: dict) -> str:
    return jwt.encode({**data, "exp": datetime.utcnow() + timedelta(days=7)}, SECRET_KEY)

async def get_current_user(request: Request) -> User | None:
    token = request.cookies.get("access_token")
    if not token:
        return None
    payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    return await user_service.get_by_id(int(payload.get("sub")))
```

---

## HTMX Origin Validation

```python
class HTMXValidationMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        if request.headers.get("HX-Request") == "true":
            if request.method in ("POST", "PUT", "DELETE"):
                origin = request.headers.get("Origin", "")
                if not any(origin.startswith(o) for o in ALLOWED_ORIGINS):
                    raise HTTPException(403, "Invalid origin")
        return await call_next(request)
```
