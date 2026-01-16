# Step 01 — ANALYZE (Understand System + Touch Points)

## Goal
Map the current codebase relevant to the goal, find the best insertion points, and identify risks.

## RLM Strategy: MAP → DRILL → EXEC

### 1. MAP Phase
Build a lightweight index before reading files:
- List directories/modules related to the goal (glob/find)
- Search for patterns (grep for classes, functions, routes)
- **Output**: candidate files list with brief descriptions

### 2. DRILL Phase
Open only what's necessary:
- Read 80-200 lines max per file chunk
- Focus on signatures, not implementations
- Follow imports only if directly relevant
- **Output**: specific line ranges + findings with pointers

### 3. EXEC Phase
Defer to Step 02 (Plan) with:
- Precise touch points (file:line)
- Minimal context needed for implementation

> **Anti-Pattern**: Opening 15 files "because they might be relevant"

## What to Inspect

### 1. Entrypoints
- CLI commands
- API server/app initialization
- Web routes
- Background workers

### 2. Domain Modules
- Data models / entities
- Business logic
- Service layers
- Repositories

### 3. Existing Patterns
- How similar features are implemented
- Naming conventions
- Error handling patterns
- Logging practices

### 4. Configuration
- Environment variables
- Config files
- Feature flags
- Secrets management

### 5. Test Coverage
- Existing tests for the area
- Test patterns used
- Fixtures and mocks

## Analysis Strategy

1. **Find closest existing feature** — locate similar endpoint/component
2. **Trace happy path** — follow execution flow end-to-end
3. **Identify change surface:**
   - Files that MUST change
   - Files that SHOULD NOT change
4. **Assess risks:**
   - Breaking API contracts
   - Backwards compatibility
   - Concurrency / race conditions
   - Performance hot spots
   - Security implications

## Second-Order Thinking

Before proceeding, ask:
- "And then what?" — downstream effects
- What breaks if this fails partially?
- What happens on retry?
- How does this affect other teams/consumers?

## Output Format

```markdown
## Current Behavior
[What happens today]

## Desired Behavior
[What should happen]

## Touch Points
- `path/to/file.py` — reason for change
- `path/to/other.py` — reason for change

## Unknowns
- [ ] Question that blocks execution

## Risk Assessment
- **Level**: low | medium | high
- **Reason**: [why this risk level]

## Stack Commands
- Format: `<command>`
- Lint: `<command>`
- Test: `<command>`
- Typecheck: `<command>`
```

## Output (PIPELINE_STATE)

```json
{
  "scope": "auth module, user routes",
  "files_touched": ["src/auth/service.py", "src/routes/user.py"],
  "risks": [
    {
      "description": "Breaking API change",
      "severity": "medium",
      "mitigation": "Add deprecation warning first"
    }
  ],
  "stack": {
    "detected": "python-uv",
    "format_command": "uv run ruff format .",
    "lint_command": "uv run ruff check .",
    "test_command": "uv run pytest -v",
    "typecheck_command": "uv run ty check"
  },
  "next_step": "step-02-plan"
}
```
