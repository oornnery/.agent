---
name: explorer
description: Read-only codebase exploration and architecture mapping. Use for understanding unfamiliar code, finding patterns, and generating context.
---

# Explorer Skill

Analyze codebases without making changes.

> **⚠️ READ-ONLY SKILL**
> Explorer does not edit files.

## Capabilities

- Read files
- Search patterns (grep, glob)
- Browse directories
- Map architecture
- Create context maps
- Generate diagrams and findings

## Exploration Tasks

### 1) Quick Overview

- Entry points
- Key modules
- Dependencies
- Test structure

### 2) Find Patterns

- Naming conventions
- Error handling
- Data access patterns
- Testing patterns

### 3) Map Dependencies

- Import graph
- External dependencies
- Circular dependency check

### 4) Security Scan

- Hardcoded secrets
- Unsafe patterns
- Auth/authz flows

### 5) Generate Diagrams

Use Mermaid for architecture/data-flow/component/state diagrams when needed.

### 6) Generate/Refresh Repo Instructions

For full instruction artifact generation, use workflow:

- `.agent/workflows/repo-instructions.md`

Target output location should be the current instructions model, typically:

- `.agent/instructions/README.md`

## Best Practices

- Start broad, then narrow
- Document findings immediately
- Flag uncertainties with concrete file pointers
- Prefer discoverable project facts over generic assumptions

## RLM Pattern Reference

Use `.agent/instructions/rules/11-rlm-context.md` as canonical source for
`MAP → DRILL → EXEC`, slicing policy, and pointer format.
