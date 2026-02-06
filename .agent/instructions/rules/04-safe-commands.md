---
name: safe-commands
description: Safe command whitelist. Reference when running shell commands.
---

# Safe Commands Whitelist

Commands the agent can run safely. Organized by category with cross-platform equivalents.

## File System (Read-Only)

| Unix/Linux | PowerShell               | Description       |
| ---------- | ------------------------ | ----------------- |
| `ls`       | `Get-ChildItem`, `dir`   | List directory    |
| `find`     | `Get-ChildItem -Recurse` | Find files        |
| `tree`     | `tree`                   | Directory tree    |
| `cat`      | `Get-Content`, `type`    | Read file         |
| `head`     | `Get-Content -Head N`    | First N lines     |
| `tail`     | `Get-Content -Tail N`    | Last N lines      |
| `wc`       | `Measure-Object`         | Count lines/words |
| `stat`     | `Get-Item`               | File info         |
| `file`     | —                        | File type         |

## File System (Mutating - with caution)

| Unix/Linux | PowerShell                     | Description                 |
| ---------- | ------------------------------ | --------------------------- |
| `mkdir`    | `New-Item -ItemType Directory` | Create directory            |
| `touch`    | `New-Item -ItemType File`      | Create file                 |
| `mv`       | `Move-Item`                    | Move/rename                 |
| `cp`       | `Copy-Item`                    | Copy                        |
| `rm`       | `Remove-Item`                  | Delete (project files only) |

## Search & Text

| Unix/Linux | PowerShell          | Description              |
| ---------- | ------------------- | ------------------------ |
| `grep`     | `Select-String`     | Search in files          |
| `rg`       | `rg`                | Ripgrep (cross-platform) |
| `sed`      | `-replace` operator | Stream edit              |
| `awk`      | —                   | Text processing          |
| `sort`     | `Sort-Object`       | Sort lines               |
| `uniq`     | `Get-Unique`        | Unique lines             |
| `jq`       | `ConvertFrom-Json`  | JSON processing          |

## Network (Local Only)

```bash
# ✓ Safe patterns
curl http://localhost:*
curl http://127.0.0.1:*
curl http://0.0.0.0:*
curl https://api.github.com  # Public APIs

# PowerShell equivalent
Invoke-WebRequest http://localhost:8000
Invoke-RestMethod http://127.0.0.1:3000/api
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

| Unix/Linux | PowerShell           | Description       |
| ---------- | -------------------- | ----------------- |
| `cd`       | `Set-Location`       | Change directory  |
| `pwd`      | `Get-Location`       | Current directory |
| `echo`     | `Write-Output`       | Print text        |
| `sleep`    | `Start-Sleep`        | Wait              |
| `date`     | `Get-Date`           | Current date/time |
| `env`      | `Get-ChildItem Env:` | Environment vars  |
| `which`    | `Get-Command`        | Find command path |

## Forbidden Commands

```bash
# ❌ Never run (any platform)
sudo, su, chmod 777, rm -rf /
passwd, useradd, chown (root), shutdown, reboot
Remove-Item -Recurse -Force /  # PowerShell equivalent
```

## Network Safety Rules

| Pattern          | Status  | Example                                   |
| ---------------- | ------- | ----------------------------------------- |
| `localhost:*`    | ✅ Safe | `curl http://localhost:8000`              |
| `127.0.0.1:*`    | ✅ Safe | `Invoke-WebRequest http://127.0.0.1:3000` |
| `0.0.0.0:*`      | ✅ Safe | `curl http://0.0.0.0:5000`                |
| Public APIs      | ✅ Safe | `curl https://api.github.com`             |
| Unknown external | ⚠️ Ask  | `curl https://random-site.com`            |

## Before Running Commands

1. **Verify command is in whitelist**
2. **Check target paths are within project**
3. **For network requests, verify localhost or known API**
4. **When in doubt, ask user**
