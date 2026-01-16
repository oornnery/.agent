# Step 00 — INIT (Branch + Workspace)

## Goal
Prepare a clean starting point for implementation.

## Actions

### 1. Confirm Repository Status
```bash
# Ensure working tree is clean
git status --porcelain

# Ensure correct base branch
git branch --show-current

# Pull latest changes (fast-forward only)
git pull --ff-only
```

### 2. Create Feature Branch

Use safe naming convention:

| Type | Prefix | Example |
|------|--------|---------|
| Feature | `feat/` | `feat/add-login` |
| Bug fix | `fix/` | `fix/null-pointer` |
| Chore | `chore/` | `chore/update-deps` |
| Refactor | `refactor/` | `refactor/auth-module` |
| Docs | `docs/` | `docs/api-guide` |

**Slug rules:**
- kebab-case
- keep it short (max 50 chars)
- include ticket ID if present: `feat/ABC-123-add-login`

```bash
git checkout -b feat/<slug>
```

### 3. Create APEX Scratchpad

Initialize mental state (not necessarily a file):
- Goal summary (1 line)
- Constraints (stack, style, deadlines)
- Definition of done

## Output (APEX_STATE)

```json
{
  "goal": "<one-line goal>",
  "mode": "auto",
  "branch": "feat/<slug>",
  "base_branch": "main",
  "next_step": "step-01-analyze"
}
```

## Checklist

- [ ] Working tree clean
- [ ] On correct base branch
- [ ] Latest changes pulled
- [ ] Feature branch created
- [ ] Goal clearly defined
