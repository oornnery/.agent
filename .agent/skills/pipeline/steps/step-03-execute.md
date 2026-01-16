# Step 03 — EXECUTE (Implement in Small Diffs)

## Goal
Implement the plan with clean incremental changes.

## Core Rules

### Small Diffs
- Each change should be **reviewable in < 5 minutes**
- One logical change per file edit
- Avoid combining unrelated changes

### Follow Existing Patterns
- Match naming conventions in the codebase
- Use existing utilities and helpers
- Don't reinvent what exists

### Code Quality
- Add meaningful comments only when non-obvious
- Use clear variable/function names
- Handle errors explicitly
- Add type hints (if applicable)

### Avoid Anti-Patterns
- ❌ "While we're here" refactors
- ❌ Unrelated improvements
- ❌ Debug prints left behind
- ❌ Commented-out code
- ❌ TODO without ticket reference

## Execution Workflow

For each task in the plan:

```
1. Read relevant files
2. Make smallest change
3. Run quick validation:
   - Format check
   - Lint check
   - Type check (if fast)
4. Checkpoint summary
5. Move to next task
```

## Quick Validation Commands

Run after each meaningful change:

```bash
# Python (uv)
uv run ruff format .
uv run ruff check .

# Node (pnpm)
pnpm lint
pnpm format

# Go
go fmt ./...
go vet ./...

# Rust
cargo fmt
cargo clippy
```

## Progress Tracking

After each task, update mental state:

```markdown
## Task: [Name]
- Status: ✅ Complete
- Files changed:
  - `path/to/file.py` — what changed
- Validation: format ✅ lint ✅
```

## Output (PIPELINE_STATE)

```json
{
  "current_step": "step-03-execute",
  "files_touched": [
    "src/models/user.py",
    "src/services/user_service.py"
  ],
  "files_created": [
    "src/routes/users.py"
  ],
  "commands_run": [
    "uv run ruff format .",
    "uv run ruff check ."
  ],
  "risks": [],
  "next_step": "step-04-validate"
}
```

## Red Flags — Stop and Reassess

If you encounter:
- Need to change > 10 files
- Circular dependency introduced
- Breaking API contract
- Unclear requirements
- Test failures in unrelated areas

→ Stop, document the blocker, and ask for guidance (or reassess plan).
