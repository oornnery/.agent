---
name: node
description: Node.js ecosystem skill with flexible package-manager/runtime guidance (bun, pnpm, npm), TypeScript-first defaults, and JavaScript fallback.
---

# Node Skill

Use this skill for Node.js projects across JavaScript and TypeScript stacks.

## Scope

- Stack detection (TS-first vs JS)
- Package manager and runtime choice (`bun`, `pnpm`, `npm`)
- Validation workflow (format, lint, typecheck when applicable, test)
- Build and execution conventions

## Loading Order

1. `.agent/skills/node/selection.md`
2. `.agent/skills/node/typescript.md` (priority when TS is detected)
3. `.agent/skills/node/js.md` (for pure JS or JS-specific constraints)
4. One package manager/runtime file according to lock/config:
   - `.agent/skills/node/bun.md`
   - `.agent/skills/node/pnpm.md`
   - `.agent/skills/node/npm.md`

## TypeScript Priority Rule

When any of the following is true, treat TypeScript as primary:

- `tsconfig.json` exists
- source has `.ts`/`.tsx` as main implementation
- project scripts include explicit TS build/typecheck

In TypeScript-first projects, always run typecheck before tests.

## Guardrails

- Do not force one package manager across all repositories.
- Choose commands from the detected manager/runtime file only.
- Keep local validation aligned with CI scripts.
