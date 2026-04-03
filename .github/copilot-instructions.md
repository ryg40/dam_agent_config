# Copilot Instructions

This repository uses a lightweight, human-driven workflow system.

## Philosophy

- **Human-driven**: Humans orchestrate, agents assist
- **Documentation-first**: State is always captured in markdown
- **Atomic commits**: Each logical change = one commit
- **Scan and sync**: Run `/document` anytime to capture drift

## Available Commands

| Command | Purpose |
|---------|---------|
| `/plan` | Break requirements into atomic tasks |
| `/execute` | Implement next task with atomic commit |
| `/review` | Review current changes |
| `/document` | Scan diffs, update STATE.md |

## State Files

**IMPORTANT**: All state files live in `/agent-docs/` so all agent frameworks can access them.

```
agent-docs/
  STATE.md      - Current phase, in-progress work, blockers
  PLAN.md       - Task breakdown with checkboxes
  CHANGELOG.md  - Human-readable change log
```

**Every command must update `/agent-docs/` after every action.**

### Efficient Reads

State files use a **header/history** structure:
- **First 50 lines**: Actionable state (read this for quick context)
- **Below the `---`**: History/logs (read only when debugging)

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks
```

## Commit Style

Use atomic commits with this format:

```
<type>: <description>

Task: <task name from plan>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Workflow

1. User describes what they want
2. `/plan` breaks it into tasks
3. `/execute` implements one task at a time
4. `/review` checks quality
5. `/document` syncs state anytime

Run `/document` frequently to keep STATE.md accurate.
