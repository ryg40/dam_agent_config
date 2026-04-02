# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Purpose

A lightweight, human-driven workflow system inspired by [GSD](https://github.com/gsd-build/get-shit-done). Focused on documentation maintenance and atomic commits.

## Philosophy

- **Human-driven**: Humans orchestrate, agents assist
- **Documentation-first**: State is always captured in markdown
- **Atomic commits**: Each logical change = one commit
- **Scan and sync**: Run `/document` anytime to capture drift

## Repository Structure

```
.claude/commands/       - Claude Code slash commands
.opencode/commands/     - OpenCode slash commands
.github/
  copilot-instructions.md  - Copilot general instructions
  prompts/              - Copilot prompt files
templates/              - Templates for state files
agents.md               - Agent definitions and docs
STATE.md                - Current work state (per-project)
PLAN.md                 - Task breakdown (per-project)
CHANGELOG.md            - Change history (per-project)
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

**Every command must update `/agent-docs/` after every action.**

## Commit Style

Each commit should be atomic and focused:

```
<type>: <description>

Task: <task name from plan>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

## Development Commands

This is a configuration/documentation repository. No build or test commands.

## Git Workflow

- Branch naming: `claude/` prefix for automated branches
- Changes merged via pull requests
- Atomic commits per completed task
