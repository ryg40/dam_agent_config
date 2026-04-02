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
.claude/commands/   - Slash commands for Claude Code
  plan.md           - /plan - Create task plans
  execute.md        - /execute - Implement tasks
  review.md         - /review - Review changes
  document.md       - /document - Sync state with reality
templates/          - Templates for state files
agents.md           - Agent definitions and workflow docs
STATE.md            - Current work state (created per-project)
PLAN.md             - Task breakdown (created per-project)
CHANGELOG.md        - Change history (created per-project)
```

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

When working on a project, these files track state:

- **STATE.md** - Current phase, in-progress work, blockers
- **PLAN.md** - Task breakdown with checkboxes
- **CHANGELOG.md** - Human-readable change log

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
