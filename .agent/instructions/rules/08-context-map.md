---
name: context-map
description: Repository mapping protocol for low-drift analysis. Apply at the start of discovery, planning, or large review tasks.
---

# Context Map Rule

Use a lightweight structural map before deep analysis to reduce context drift.

## When To Apply

- Start of repository discovery
- Start of technical planning
- Large or unfamiliar codebase analysis
- Major review sessions with broad impact

## Minimum Mapping Output

Produce a concise map with:

1. Entry points
2. Core modules/domains
3. Test locations
4. Key config files
5. Candidate hotspots (frequent changes or central dependencies)

## Mapping Process

1. Scan directory structure and top-level modules.
2. Identify runtime/build/test entry points.
3. Detect stack/tooling files (`pyproject.toml`, `package.json`, `go.mod`, `Cargo.toml`, etc.).
4. Record likely impact zones before drilling into implementation details.

## Interaction With RLM Strategy

- Use this rule first for map creation.
- Then use `.agent/instructions/rules/11-rlm-context.md` for `MAP → DRILL → EXEC` slicing depth and pointer format.

## Guardrails

- Keep mapping read-first and evidence-based.
- Prefer repository facts over assumptions.
- Refresh map when branch or major scope changes.
