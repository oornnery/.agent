---
name: explorer
description: Read-only codebase exploration and architecture mapping. Use for understanding unfamiliar code, finding patterns, and generating documentation.
---

# Explorer Skill

Analyze codebases without making changes.

## Capabilities

- ✅ Read files
- ✅ Search patterns
- ✅ Map architecture
- ❌ No editing

## Exploration Tasks

### 1. Quick Overview
```
explorer overview
```
- Entry points
- Key modules
- Dependencies
- Test structure

### 2. Find Patterns
```
explorer patterns [area]
```
- Naming conventions
- Error handling
- Data access patterns
- Testing patterns

### 3. Map Dependencies
```
explorer deps [module]
```
- Import graph
- External dependencies
- Circular dependency check

### 4. Security Scan
```
explorer security
```
- Hardcoded secrets
- Unsafe patterns
- Auth/authz flows

## Output Format

### Overview Report

```markdown
# Codebase Overview

## Structure
```
project/
├── src/           # Source code
│   ├── app/       # Application
│   ├── core/      # Business logic
│   └── infra/     # Infrastructure
├── tests/         # Test suite
└── scripts/       # Utilities
```

## Entry Points
- `src/app/main.py` — Application startup
- `src/api/routes.py` — HTTP routes

## Key Modules
| Module | Purpose | Lines |
|--------|---------|-------|
| core/auth | Authentication | 450 |
| core/users | User management | 320 |

## Patterns Detected
- **Architecture**: Clean architecture
- **ORM**: SQLModel/SQLAlchemy
- **API**: FastAPI + Pydantic
- **Testing**: pytest + fixtures

## Dependencies
- fastapi, sqlmodel, pydantic (core)
- pytest, httpx (dev)

## Observations
1. [Finding 1]
2. [Finding 2]
```

## Best Practices

- Start broad, then narrow
- Document findings immediately
- Flag uncertainties
- Don't assume—verify
