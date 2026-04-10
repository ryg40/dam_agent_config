# CLAUDE.md

Claude Code specific instructions. For universal rules all agents follow, see [AGENTS.md](AGENTS.md).

## Repository Purpose

A lightweight, human-driven workflow system. Configuration/documentation repository. No build or test commands.

## Repository Structure

```
AGENTS.md                   - Universal agent instructions
CLAUDE.md                   - This file (Claude Code specific)
opencode.json               - OpenCode project config
agents.md                   - Agent reference documentation
agent-docs/                 - Shared state files
.opencode/agents/           - OpenCode agent definitions
.opencode/commands/         - OpenCode slash commands
.claude/commands/           - Claude Code slash commands
.github/prompts/            - Copilot prompt files
```

## Tool Compatibility

Commands work across:
- **Claude Code**: `.claude/commands/*.md`
- **OpenCode**: `.opencode/commands/*.md`  
- **Copilot Chat**: `.github/prompts/*.prompt.md`

## Commands

| Command | Purpose |
|---------|---------|
| `/plan <requirement>` | Break work into atomic tasks |
| `/execute [task]` | Implement next task, atomic commit |
| `/review` | Review current changes |
| `/document` | Scan diffs, update STATE.md |

## Workflow

1. Human describes what they want
2. `/plan` breaks it into tasks
3. `/execute` implements one task at a time
4. `/review` checks quality
5. `/document` syncs state anytime

Run `/document` frequently to keep STATE.md accurate.

## State Files

**IMPORTANT**: All state files live in `/agent-docs/` so all agent frameworks can access them.

```
agent-docs/
  STATE.md      - Current phase, in-progress work, blockers
  PLAN.md       - Task breakdown with checkboxes
  CHANGELOG.md  - Human-readable change log
```

### Efficient Reads

State files use a **header/history** structure:
- **First 50 lines**: Actionable state (read this for quick context)
- **Below the `---`**: History/logs (read only when debugging)

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks
```

This prevents context bloat as history grows.

## Commit Style

Each commit should be atomic and focused:

```
<type>: <description>

Task: <task name from plan>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Git Workflow

- Branch naming: `claude/` prefix for automated branches
- Changes merged via pull requests
- Atomic commits per completed task
