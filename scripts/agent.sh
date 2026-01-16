#!/bin/bash

# Agent Skills Manager
# Usage: ./agent.sh <command> [options]
# 
# Commands:
#   init <agent> [--skills <list>] [--stack <stack>]
#   add <skill|stack|rule> [target]
#   list [skills|stacks|rules|agents]
#   status

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_SKILLS="$AGENT_ROOT/skills"
SOURCE_RULES="$AGENT_ROOT/rules"

# Agent target paths
declare -A AGENTS=(
    ["opencode"]=".opencode/skill"
    ["claude"]=".claude/skills"
    ["codex"]=".codex/skills"
    ["cursor"]=".cursor/skills"
    ["amp"]=".agents/skills"
    ["antigravity"]=".agent/skills"
    ["copilot"]=".copilot/skills"
)

# Available skills
declare -A SKILLS=(
    ["pipeline"]="End-to-end dev workflow (feature → PR)"
    ["handoff"]="Context management and session transfer"
    ["explorer"]="Codebase analysis (read-only)"
    ["code-review"]="Self-review patterns"
    ["git-workflow"]="Branch, commit, PR management"
    ["test-runner"]="Test execution and coverage"
    ["refactor"]="Code improvement patterns"
    ["debugger"]="Issue diagnosis"
    ["documenter"]="Documentation generation"
    ["ship-fast"]="Quick iterations"
    ["security-audit"]="Security review"
    ["performance"]="Performance optimization"
)

# Available stacks
declare -A STACKS=(
    ["python"]="Python with uv + ruff + ty + pytest"
    ["python-uv"]="Python with uv + ruff + ty + pytest"
    ["node"]="Node.js with pnpm"
    ["node-pnpm"]="Node.js with pnpm"
    ["go"]="Go with standard tooling"
    ["rust"]="Rust with cargo"
)

# Rule categories
declare -A RULE_CATEGORIES=(
    ["core"]="Always-apply rules (scope, protocol)"
    ["tooling"]="Dev tools (uv, ruff, testing)"
    ["architecture"]="System design patterns"
    ["frontend"]="UI/UX patterns (jx, htmx)"
    ["backend"]="API/DB patterns"
    ["realtime"]="Streaming/events (SSE, faststream)"
)

print_usage() {
    cat << 'EOF'
Agent Skills Manager

Usage: ./agent.sh <command> [options]

Commands:
  init <agent>              Initialize agent with symlinks
    --skills <list>         Comma-separated skills (default: all)
    --stack <stack>         Stack-specific rules (python, node, go, rust)
    --rules <categories>    Rule categories (core, backend, frontend, etc.)

  add <type> <name>         Add specific component
    skill <name>            Add a skill (apex, handoff, etc.)
    stack <name>            Add stack guide (python, node, etc.)
    rule <category>         Add rule category

  list [type]               List available components
    skills                  Show available skills
    stacks                  Show available stacks
    rules                   Show rule categories
    agents                  Show supported agents

  status                    Show current setup status

Examples:
  # Full setup for Claude
  ./agent.sh init claude

  # Only Python backend skills
  ./agent.sh init claude --skills apex,test-runner --stack python --rules core,backend

  # Add just apex skill
  ./agent.sh add skill apex

  # Add only Python stack
  ./agent.sh add stack python

  # List all skills
  ./agent.sh list skills
EOF
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_info() { echo -e "${BLUE}→${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

# Get project root (where .agent will be created)
get_project_root() {
    if [[ -n "$PROJECT_ROOT" ]]; then
        echo "$PROJECT_ROOT"
    else
        echo "$(pwd)"
    fi
}

# List available components
list_components() {
    local type="${1:-all}"
    
    case "$type" in
        skills)
            echo "Available Skills:"
            echo ""
            for skill in "${!SKILLS[@]}"; do
                printf "  %-20s %s\n" "$skill" "${SKILLS[$skill]}"
            done | sort
            ;;
        stacks)
            echo "Available Stacks:"
            echo ""
            for stack in "${!STACKS[@]}"; do
                printf "  %-20s %s\n" "$stack" "${STACKS[$stack]}"
            done | sort
            ;;
        rules)
            echo "Rule Categories:"
            echo ""
            for cat in "${!RULE_CATEGORIES[@]}"; do
                printf "  %-20s %s\n" "$cat" "${RULE_CATEGORIES[$cat]}"
            done | sort
            ;;
        agents)
            echo "Supported Agents:"
            echo ""
            for agent in "${!AGENTS[@]}"; do
                printf "  %-20s → %s\n" "$agent" "${AGENTS[$agent]}"
            done | sort
            ;;
        *)
            list_components skills
            echo ""
            list_components stacks
            echo ""
            list_components rules
            echo ""
            list_components agents
            ;;
    esac
}

# Add a skill
add_skill() {
    local skill="$1"
    local target_dir="$2"
    
    if [[ -z "${SKILLS[$skill]}" && "$skill" != "all" ]]; then
        log_error "Unknown skill: $skill"
        log_info "Available: ${!SKILLS[*]}"
        return 1
    fi
    
    local source="$SOURCE_SKILLS/$skill"
    local target="$target_dir/$skill"
    
    if [[ ! -d "$source" ]]; then
        log_warn "Skill source not found: $source"
        return 1
    fi
    
    # Create parent if needed
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    if [[ -L "$target" ]]; then
        rm "$target"
    elif [[ -d "$target" ]]; then
        log_warn "$skill exists as directory, skipping"
        return 0
    fi
    
    local rel_source=$(realpath --relative-to="$(dirname "$target")" "$source")
    ln -s "$rel_source" "$target"
    log_success "Added skill: $skill"
}

# Add stack guide
add_stack() {
    local stack="$1"
    local target_dir="$2"
    
    # Normalize stack name
    case "$stack" in
        python) stack="python-uv" ;;
        node) stack="node-pnpm" ;;
    esac
    
    local source="$SOURCE_SKILLS/apex/stacks/${stack}.md"
    local target="$target_dir/apex/stacks/${stack}.md"
    
    if [[ ! -f "$source" ]]; then
        log_warn "Stack guide not found: $source"
        return 1
    fi
    
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
    log_success "Added stack: $stack"
}

# Initialize agent
init_agent() {
    local agent="$1"
    shift
    
    # Parse options
    local skills="all"
    local stack=""
    local rules="all"
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --skills)
                skills="$2"
                shift 2
                ;;
            --stack)
                stack="$2"
                shift 2
                ;;
            --rules)
                rules="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    if [[ -z "${AGENTS[$agent]}" && "$agent" != "all" ]]; then
        log_error "Unknown agent: $agent"
        log_info "Available: ${!AGENTS[*]}"
        return 1
    fi
    
    local project_root=$(get_project_root)
    
    if [[ "$agent" == "all" ]]; then
        log_info "Initializing all agents..."
        for a in "${!AGENTS[@]}"; do
            init_single_agent "$a" "$project_root" "$skills" "$stack" "$rules"
        done
    else
        init_single_agent "$agent" "$project_root" "$skills" "$stack" "$rules"
    fi
    
    echo ""
    log_success "Done!"
}

init_single_agent() {
    local agent="$1"
    local project_root="$2"
    local skills="$3"
    local stack="$4"
    local rules="$5"
    
    local target_path="${AGENTS[$agent]}"
    local full_target="$project_root/$target_path"
    local target_dir=$(dirname "$full_target")
    
    echo ""
    log_info "Initializing $agent..."
    
    # Create directory
    mkdir -p "$target_dir"
    
    # Handle skills
    if [[ "$skills" == "all" ]]; then
        # Link entire skills directory
        if [[ -L "$full_target" ]]; then
            rm "$full_target"
        fi
        
        local rel_source=$(realpath --relative-to="$target_dir" "$SOURCE_SKILLS")
        ln -s "$rel_source" "$full_target"
        log_success "Linked all skills"
    else
        # Create target directory and add specific skills
        mkdir -p "$full_target"
        IFS=',' read -ra skill_list <<< "$skills"
        for skill in "${skill_list[@]}"; do
            skill=$(echo "$skill" | xargs)  # trim whitespace
            add_skill "$skill" "$full_target"
        done
    fi
    
    # Add specific stack if requested
    if [[ -n "$stack" ]]; then
        add_stack "$stack" "$full_target"
    fi
}

# Show status
show_status() {
    local project_root=$(get_project_root)
    
    echo "Agent Skills Status"
    echo "==================="
    echo ""
    echo "Project Root: $project_root"
    echo "Source: $AGENT_ROOT"
    echo ""
    
    printf "%-15s %-25s %s\n" "AGENT" "PATH" "STATUS"
    printf "%-15s %-25s %s\n" "-----" "----" "------"
    
    for agent in "${!AGENTS[@]}"; do
        local target="${AGENTS[$agent]}"
        local full_target="$project_root/$target"
        local status
        
        if [[ -L "$full_target" ]]; then
            local link_target=$(readlink "$full_target")
            status="${GREEN}✓ → $link_target${NC}"
        elif [[ -d "$full_target" ]]; then
            local count=$(find "$full_target" -maxdepth 1 -type l -o -type d 2>/dev/null | wc -l)
            status="${YELLOW}⚠ dir ($count items)${NC}"
        else
            status="${RED}✗ not setup${NC}"
        fi
        
        printf "%-15s %-25s %b\n" "$agent" "$target" "$status"
    done
}

# Add component
add_component() {
    local type="$1"
    local name="$2"
    local project_root=$(get_project_root)
    local target="$project_root/.agent/skills"
    
    mkdir -p "$target"
    
    case "$type" in
        skill)
            add_skill "$name" "$target"
            ;;
        stack)
            add_stack "$name" "$target"
            ;;
        rule)
            log_info "Rule linking not yet implemented"
            ;;
        *)
            log_error "Unknown type: $type"
            echo "Available: skill, stack, rule"
            return 1
            ;;
    esac
}

# Main
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
    init)
        if [[ -z "${1:-}" ]]; then
            log_error "Agent name required"
            echo "Usage: $0 init <agent> [--skills list] [--stack name]"
            exit 1
        fi
        init_agent "$@"
        ;;
    add)
        if [[ -z "${1:-}" || -z "${2:-}" ]]; then
            log_error "Type and name required"
            echo "Usage: $0 add <skill|stack|rule> <name>"
            exit 1
        fi
        add_component "$1" "$2"
        ;;
    list)
        list_components "${1:-all}"
        ;;
    status)
        show_status
        ;;
    *)
        print_usage
        exit 1
        ;;
esac
