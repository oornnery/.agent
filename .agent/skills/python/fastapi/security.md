
# FastAPI Security

Comprehensive security reference for FastAPI applications. Covers XSS prevention, CSRF, SQL injection, authentication, password hashing, security headers, rate limiting, file uploads, and OWASP top 10.

## 2. CORS

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],  # NEVER ["*"] with credentials
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Content-Type", "Authorization", "X-CSRF-Token"],
    max_age=3600
)
```

## 4. CSRF Protection

```python
# API endpoints: Use JWT in Authorization header (immune to CSRF)
# Form endpoints: Use CSRF tokens

@app.post("/forms/contact")
async def contact(request: Request, csrf_protect: CsrfProtect = Depends()):
    await csrf_protect.validate_csrf(request)
    form_data = await request.form()
    ...
```

```jinja
<form method="POST" action="/forms/contact">
    <input type="hidden" name="csrf_token" value="{{ csrf_token }}">
    ...
</form>
```

## 6. Authentication (JWT)

```python
from passlib.context import CryptContext
from jose import jwt, JWTError
from fastapi.security import OAuth2PasswordBearer

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm="HS256")

async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[AsyncSession, Depends(get_db)]
) -> User:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if user is None:
        raise credentials_exception
    return user

@app.post("/token")
async def login(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    db: Annotated[AsyncSession, Depends(get_db)]
):
    result = await db.execute(select(User).where(User.email == form_data.username))
    user = result.scalar_one_or_none()
    if not user or not pwd_context.verify(form_data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Incorrect credentials")
    access_token = create_access_token(data={"sub": str(user.id)})
    return {"access_token": access_token, "token_type": "bearer"}
```

### Password Hashing (Modern)

```python
# Option 1: passlib + bcrypt
from passlib.context import CryptContext
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto", bcrypt__rounds=12)

# Option 2: pwdlib + argon2 (OWASP recommended)
from pwdlib import PasswordHash
password_hash = PasswordHash.recommended()
hashed = password_hash.hash("password")
is_valid = password_hash.verify("password", hashed)
```

## 8. File Upload Validation

```python
import magic

async def validate_image(file: UploadFile) -> UploadFile:
    content = await file.read()
    if len(content) > 5 * 1024 * 1024:
        raise HTTPException(status_code=413, detail="File too large (max 5MB)")
    mime = magic.from_buffer(content, mime=True)
    if mime not in ["image/jpeg", "image/png", "image/webp"]:
        raise HTTPException(status_code=400, detail=f"Invalid type: {mime}")
    await file.seek(0)
    return file

@app.post("/upload")
async def upload(
    file: Annotated[UploadFile, File()],
    form: Annotated[FileUploadForm, Form()]
):
    validated = await validate_image(file)
    ...
```

**Pitfalls**: Validate file MIME via magic numbers, not Content-Type header. Always set file size limits. Never trust the filename.

## 10. HTTPS Enforcement

```python
from starlette.middleware.httpsredirect import HTTPSRedirectMiddleware

if settings.environment == "production":
    app.add_middleware(HTTPSRedirectMiddleware)
```

---

## Security Summary Checklist (Merged)

## Security Features

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
