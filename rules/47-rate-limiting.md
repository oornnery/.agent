---
name: rate-limiting
description: Request rate limiting with slowapi. Use when protecting endpoints from abuse or implementing API throttling.
---

# Rate Limiting

## Rate Limits per Endpoint

| Endpoint   | Limit       |
|------------|-------------|
| Global     | 60/minute   |
| Login      | 10/minute   |
| Register   | 5/minute    |
| Contact    | 10/minute   |

---

## Implementation (slowapi)

```python
from slowapi import Limiter
from slowapi.util import get_remote_address
from slowapi.middleware import SlowAPIMiddleware

limiter = Limiter(key_func=get_remote_address, default_limits=["60/minute"])

app = FastAPI()
app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)

# Per-endpoint limits
@router.post("/auth/login")
@limiter.limit("10/minute")
async def login(request: Request, data: LoginRequest):
    ...

@router.post("/auth/register")
@limiter.limit("5/minute")
async def register(request: Request, data: RegisterRequest):
    ...

@router.post("/contact")
@limiter.limit("10/minute")
async def contact(request: Request, data: ContactRequest):
    ...
```

---

## Custom error handler

```python
from slowapi.errors import RateLimitExceeded

@app.exception_handler(RateLimitExceeded)
async def rate_limit_handler(request: Request, exc: RateLimitExceeded):
    return JSONResponse(
        status_code=429,
        content={"detail": "Rate limit exceeded. Try again later."}
    )
```
