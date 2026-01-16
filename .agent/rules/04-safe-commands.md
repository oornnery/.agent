---
name: safe-commands
description: Safe command whitelist. Reference when running shell commands.
---

# Safe Commands Whitelist

Commands the agent can run safely. Organized by category.

## File System (Read-Only)
```bash
ls, find, tree, stat, file, cat, head, tail, less, wc
```

## File System (Mutating - with caution)
```bash
mkdir, touch, mv, cp, rm     # Only on project files
```

## Search & Text
```bash
grep, rg, awk, sed, sort, uniq, cut, tr, jq, yq
```

## Network (Local Only)
```bash
curl http://localhost:*      # ✓ Safe
curl http://127.0.0.1:*      # ✓ Safe
curl http://0.0.0.0:*        # ✓ Safe
curl https://api.github.com  # ✓ Safe (public APIs)
```

## Package Managers
```bash
# Python
uv, uvx, pip list, pip show

# Node
npm, npx, pnpm, bun

# Go
go build, go test, go mod, go run

# Rust
cargo build, cargo test, cargo run, cargo check
```

## Build & Test
```bash
make, task, just
pytest, vitest, jest, go test, cargo test
ruff, eslint, prettier, ty, mypy
```

## Git
```bash
git status, git diff, git log, git branch
git add, git commit, git push, git pull
```

## Utilities
```bash
cd, pwd, echo, printf, sleep, date, env, which
```

## Forbidden Commands
```bash
# ❌ Never run
sudo, su, chmod 777, rm -rf /, curl <external-unknown>
passwd, useradd, chown (root), shutdown, reboot
```

## Network Safety Rules

| Pattern | Status | Example |
|---------|--------|---------|
| `localhost:*` | ✅ Safe | `curl http://localhost:8000` |
| `127.0.0.1:*` | ✅ Safe | `curl http://127.0.0.1:3000` |
| `0.0.0.0:*` | ✅ Safe | `curl http://0.0.0.0:5000` |
| Public APIs | ✅ Safe | `curl https://api.github.com` |
| Unknown external | ⚠️ Ask | `curl https://random-site.com` |

## Before Running Commands

1. **Verify command is in whitelist**
2. **Check target paths are within project**
3. **For network requests, verify localhost or known API**
4. **When in doubt, ask user**
