---
name: agent-protocol
description: Safety rules for AI agents. Use always when making code changes.
---

# Agent protocol (safety)
- Read files before editing; do not hallucinate paths/APIs.
- Keep edits small and verifiable.
- Never delete files without explicit request.
- After edits, run: format + lint + typecheck + tests.
