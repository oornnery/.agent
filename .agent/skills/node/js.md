# JavaScript Profile

Apply this profile for pure JavaScript projects or JS-only parts of mixed stacks.

## Standards

- Prefer `const` by default
- Keep functions small and side effects explicit
- Prefer `async/await` over nested promise chains
- Keep module boundaries clear

## Validation Priority

1. Format check
2. Lint
3. Tests
4. Build smoke check (if build step exists)

## Guardrails

- Keep scripts deterministic in CI.
- If the project evolves to TS-first, switch to `.agent/skills/node/typescript.md`.
