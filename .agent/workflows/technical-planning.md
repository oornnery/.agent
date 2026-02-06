# Workflow: Technical Planning

Use this workflow to generate a complete technical plan for a new system.

## Minimum Input

- `system_name`
- `core_features`
- `tech_stack` (optional; default Python async)
- `target_environment`

## Execution

1. Load the base prompt from `.agent/prompts/technical-planning-model.prompt.md`.
2. Inject context variables.
3. Generate the final Markdown plan with:
   - requirements
   - architecture
   - project structure
   - implementation guides
   - anti-patterns
4. Review whether the plan is actionable and implementation-ready without ambiguity.

## Expected Output

- A self-contained, versionable technical document ready for handoff.
