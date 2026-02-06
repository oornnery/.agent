# Workflow: Validate Knowledge Base

Use this workflow to validate docs/skills/agents consistency after structural changes.

## Checks

1. Structural inventory:
   - `find .agent -maxdepth 4 -type f | sort`
2. Broken path references:
   - scan `.agent` and `README.md` for `.agent/...` references
   - verify each referenced path exists
3. Agent/skill consistency:
   - every skill in agent frontmatter exists
   - every listed official agent has a file
4. Legacy residue:
   - search for removed/legacy paths and names

## Expected Output

- Pass/fail per check
- Missing paths and stale references
- Minimal remediation list
