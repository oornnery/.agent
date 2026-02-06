# TypeScript Profile

Apply this profile when TypeScript-first mode is detected.

## Standards

- Avoid `any`; prefer `unknown` + narrowing
- Use explicit return types for public APIs
- Model external payloads/contracts with dedicated types
- Keep strict compiler settings enabled

## Validation Priority

1. Format check
2. Lint
3. Typecheck (mandatory)
4. Tests

## Typecheck Commands

- `pnpm exec tsc --noEmit`
- `npm run typecheck`
- `bun run typecheck`

Use the command style that matches the selected manager/runtime file.

## Guardrails

- Do not bypass compiler errors with broad assertions.
- Keep runtime validation on trust boundaries (API input, env vars, external data).
