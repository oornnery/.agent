# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "typer>=0.21.1",
# ]
# ///
"""
Agent Skills Manager - CLI for managing AI agent skills and symlinks.

Usage:
    uvx agent.py init <agent> [--skills <list>] [--stack <stack>]
    uvx agent.py add <type> <name>
    uvx agent.py list [skills|stacks|agents]
    uvx agent.py status
"""

from pathlib import Path
from typing import Annotated

import typer
from rich import print as rprint
from rich.console import Console
from rich.table import Table

app = typer.Typer(
    name="agent",
    help="Agent Skills Manager - Manage AI agent skills and symlinks",
    no_args_is_help=True,
)
console = Console()

# ============================================
# Configuration
# ============================================

SCRIPT_DIR = Path(__file__).parent
AGENT_ROOT = SCRIPT_DIR.parent
SOURCE_SKILLS = AGENT_ROOT / ".agent" / "skills"
SOURCE_STACKS = AGENT_ROOT / ".agent" / "stacks"

AGENT_CONFIGS: dict[str, dict] = {
    "opencode": {
        "path": ".opencode/skill",
        "instructions_file": None,
        "rules_file": None,
        "description": "OpenCode AI editor",
    },
    "claude": {
        "path": ".claude/skills",
        "instructions_file": "CLAUDE.md",
        "rules_file": ".claude/settings.json",
        "description": "Claude Code (Anthropic)",
    },
    "codex": {
        "path": ".codex/skills",
        "instructions_file": "AGENTS.md",
        "rules_file": None,
        "description": "OpenAI Codex CLI",
    },
    "cursor": {
        "path": ".cursor/skills",
        "instructions_file": ".cursorrules",
        "rules_file": ".cursor/settings.json",
        "description": "Cursor AI editor",
    },
    "amp": {
        "path": ".agents/skills",
        "instructions_file": "AGENTS.md",
        "rules_file": None,
        "description": "Amp (Sourcegraph)",
    },
    "antigravity": {
        "path": ".agent/skills",
        "instructions_file": "GEMINI.md",
        "rules_file": None,
        "description": "Gemini CLI (Google)",
    },
    "copilot": {
        "path": ".copilot/skills",
        "instructions_file": ".github/copilot-instructions.md",
        "rules_file": None,
        "description": "GitHub Copilot",
    },
}

# Backward compatibility
AGENTS: dict[str, str] = {k: v["path"] for k, v in AGENT_CONFIGS.items()}

SKILLS: dict[str, str] = {
    "pipeline": "End-to-end dev workflow (feature → PR)",
    "handoff": "Context management and session transfer",
    "explorer": "Codebase analysis (read-only)",
    "code-review": "Self-review patterns",
    "git-workflow": "Branch, commit, PR management",
    "test-runner": "Test execution and coverage",
}

STACKS: dict[str, str] = {
    "python": "Python with uv + ruff + ty + pytest",
    "python-uv": "Python with uv + ruff + ty + pytest",
    "node": "Node.js with pnpm",
    "node-pnpm": "Node.js with pnpm",
    "go": "Go with standard tooling",
    "rust": "Rust with cargo",
}


def get_project_root() -> Path:
    """Get project root (current working directory)."""
    return Path.cwd()


def create_symlink(source: Path, target: Path) -> bool:
    """Create a symlink from target to source."""
    if not source.exists():
        rprint(f"[yellow]⚠[/yellow] Source not found: {source}")
        return False

    target.parent.mkdir(parents=True, exist_ok=True)

    if target.is_symlink():
        target.unlink()
    elif target.exists():
        rprint(f"[yellow]⚠[/yellow] {target.name} exists as directory, skipping")
        return False

    try:
        rel_source = source.relative_to(target.parent, walk_up=True)
    except ValueError:
        rel_source = source

    target.symlink_to(rel_source, target_is_directory=source.is_dir())
    return True


# ============================================
# Commands
# ============================================


@app.command()
def init(
    agent: Annotated[str, typer.Argument(help="Agent name or 'all'")],
    skills: Annotated[str | None, typer.Option("--skills", "-s", help="Comma-separated skills")] = None,
    stack: Annotated[str | None, typer.Option("--stack", "-t", help="Stack to include")] = None,
):
    """Initialize agent with skill symlinks."""
    if agent != "all" and agent not in AGENTS:
        rprint(f"[red]✗[/red] Unknown agent: {agent}")
        rprint(f"[dim]Available: {', '.join(AGENTS.keys())}[/dim]")
        raise typer.Exit(1)

    agents_to_init = list(AGENTS.keys()) if agent == "all" else [agent]
    project_root = get_project_root()

    for agent_name in agents_to_init:
        target_path = project_root / AGENTS[agent_name]
        rprint(f"\n[blue]→[/blue] Initializing [bold]{agent_name}[/bold]...")

        if skills is None:
            # Link entire skills directory
            if create_symlink(SOURCE_SKILLS, target_path):
                rprint(f"[green]✓[/green] Linked all skills")
        else:
            # Link specific skills
            target_path.mkdir(parents=True, exist_ok=True)
            for skill in skills.split(","):
                skill = skill.strip()
                source = SOURCE_SKILLS / skill
                target = target_path / skill
                if create_symlink(source, target):
                    rprint(f"[green]✓[/green] Added skill: {skill}")

        # Add stack if requested
        if stack:
            stack_name = "python-uv" if stack == "python" else "node-pnpm" if stack == "node" else stack
            source = SOURCE_STACKS / f"{stack_name}.md"
            if source.exists():
                target = target_path / "stacks" / f"{stack_name}.md"
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(source.read_text())
                rprint(f"[green]✓[/green] Added stack: {stack_name}")

    rprint("\n[green]✓[/green] Done!")


@app.command()
def add(
    type_: Annotated[str, typer.Argument(metavar="TYPE", help="Type: skill, stack")],
    name: Annotated[str, typer.Argument(help="Name of skill or stack")],
):
    """Add a specific skill or stack."""
    project_root = get_project_root()
    target_dir = project_root / ".agent" / "skills"
    target_dir.mkdir(parents=True, exist_ok=True)

    if type_ == "skill":
        source = SOURCE_SKILLS / name
        target = target_dir / name
        if create_symlink(source, target):
            rprint(f"[green]✓[/green] Added skill: {name}")
    elif type_ == "stack":
        stack_name = "python-uv" if name == "python" else "node-pnpm" if name == "node" else name
        source = SOURCE_STACKS / f"{stack_name}.md"
        if source.exists():
            target = target_dir / "stacks" / f"{stack_name}.md"
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(source.read_text())
            rprint(f"[green]✓[/green] Added stack: {stack_name}")
        else:
            rprint(f"[red]✗[/red] Stack not found: {name}")
    else:
        rprint(f"[red]✗[/red] Unknown type: {type_}")
        rprint("[dim]Available: skill, stack[/dim]")


@app.command("list")
def list_items(
    type_: Annotated[str | None, typer.Argument(metavar="TYPE", help="Type: skills, stacks, agents")] = None,
):
    """List available skills, stacks, or agents."""
    if type_ is None or type_ == "skills":
        table = Table(title="Available Skills", show_header=True)
        table.add_column("Skill", style="cyan")
        table.add_column("Description")
        for skill, desc in sorted(SKILLS.items()):
            table.add_row(skill, desc)
        console.print(table)

    if type_ is None or type_ == "stacks":
        if type_ is None:
            console.print()
        table = Table(title="Available Stacks", show_header=True)
        table.add_column("Stack", style="green")
        table.add_column("Description")
        for stack, desc in sorted(STACKS.items()):
            table.add_row(stack, desc)
        console.print(table)

    if type_ is None or type_ == "agents":
        if type_ is None:
            console.print()
        table = Table(title="Supported Agents", show_header=True)
        table.add_column("Agent", style="magenta")
        table.add_column("Path")
        for agent, path in sorted(AGENTS.items()):
            table.add_row(agent, path)
        console.print(table)


@app.command()
def status():
    """Show current setup status."""
    project_root = get_project_root()

    table = Table(title=f"Agent Skills Status\nProject: {project_root}", show_header=True)
    table.add_column("Agent", style="bold")
    table.add_column("Path")
    table.add_column("Status")

    for agent, path in sorted(AGENTS.items()):
        full_path = project_root / path
        if full_path.is_symlink():
            link_target = full_path.resolve()
            status = f"[green]✓ → {link_target.name}[/green]"
        elif full_path.is_dir():
            count = len(list(full_path.iterdir()))
            status = f"[yellow]⚠ dir ({count} items)[/yellow]"
        else:
            status = "[red]✗ not setup[/red]"
        table.add_row(agent, path, status)

    console.print(table)


@app.command()
def env(
    agent: Annotated[str | None, typer.Argument(help="Agent name (optional)")] = None,
):
    """Show environment configuration for agents."""
    if agent and agent not in AGENT_CONFIGS:
        rprint(f"[red]✗[/red] Unknown agent: {agent}")
        rprint(f"[dim]Available: {', '.join(AGENT_CONFIGS.keys())}[/dim]")
        raise typer.Exit(1)

    agents_to_show = [agent] if agent else list(AGENT_CONFIGS.keys())

    table = Table(title="Agent Environment Configuration", show_header=True)
    table.add_column("Agent", style="magenta")
    table.add_column("Skills Path", style="cyan")
    table.add_column("Instructions File", style="green")
    table.add_column("Description")

    for name in sorted(agents_to_show):
        config = AGENT_CONFIGS[name]
        instructions = config["instructions_file"] or "—"
        table.add_row(name, config["path"], instructions, config["description"])

    console.print(table)


if __name__ == "__main__":
    app()
