# Skills (On-Demand)

Skills are on-demand plugins. Each skill should keep a short, operational `SKILL.md`.

## Active Skills

- `design-system`
- `explorer`
- `go`
- `node`
- `python`
- `python/fastapi`
- `python/jx`
- `python/pytest`
- `rust`
- `testing`

## Convention

- `SKILL.md` should define scope, triggers, and loading order.
- Complementary content should stay inside the skill's own folder.
- Avoid duplicating global rules inside skills.

## Node Skill Note

`node` is flexible by repository stack and manager/runtime:

- language profile docs: `typescript`/`js`
- manager/runtime docs: `bun`, `pnpm`, `npm`

## Testing Skill Note

- `.agent/skills/testing/SKILL.md` is the cross-stack validation orchestrator.
- `.agent/skills/python/pytest/SKILL.md` is Python-specific deep testing guidance.

## Moved To Rules

- Code review is canonical in `.agent/instructions/rules/07-code-review.md`.
- Handoff/session transfer is canonical in `.agent/instructions/rules/06-handoff.md`.
- Context mapping is canonical in `.agent/instructions/rules/08-context-map.md`.
