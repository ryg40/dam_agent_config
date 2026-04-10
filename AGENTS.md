# AGENTS.md

Project instructions for all AI coding agents.

## Project

This is a configuration/documentation repository. No build or test commands. All changes are markdown files and config.

## Rules

1. **Read state before acting.** Run `head -50 agent-docs/STATE.md` and `head -50 agent-docs/PLAN.md` before every task. Never read the full file unless debugging.
2. **Update state after acting.** Every action must update `agent-docs/STATE.md` (progress, phase, timestamp). Mark completed tasks in `agent-docs/PLAN.md`.
3. **Atomic commits.** Each logical change = one commit. Format: `<type>: <description>` where type is feat|fix|docs|refactor|test|chore.
4. **Reference paths, not content.** In state files, write `src/app.ts:42` not the file contents.
5. **Respect read-only constraints.** `/review` and `/document` do not modify code. `/document` only updates `agent-docs/`.
6. **Bounded execution.** `/execute` assumes context is complete. Do not research or re-scope. If context is missing, stop and ask.

## State Files

All state files live in `agent-docs/`. Every agent reads and writes here.

```
agent-docs/STATE.md      - Phase, focus, blockers, progress
agent-docs/PLAN.md       - Task breakdown with checkboxes
agent-docs/CHANGELOG.md  - Change history
```

State files use header/history structure:
- **First 50 lines**: Actionable state (always read this)
- **Below `---`**: History (read only when debugging)

## Commands

| Command | Purpose | Constraint |
|---------|---------|------------|
| `/plan` | Break requirements into tasks | Updates PLAN.md and STATE.md |
| `/execute` | Implement next task | Bounded: no research, assumes context |
| `/review` | Review changes | READ-ONLY: report, don't fix |
| `/document` | Sync state with reality | CODE READ-ONLY: only updates agent-docs/ |

## Workflow

1. Human describes what they want
2. `/plan` breaks it into tasks in `agent-docs/PLAN.md`
3. `/execute` implements one task, atomic commit
4. `/review` checks quality
5. `/document` syncs state anytime

## Standalone Agents

### OneOff

Ad-hoc planner+executor for tasks outside the formal workflow. Does not update `agent-docs/`.

- Delegates all web research to `@learner` subagent
- Does NOT use webfetch or web search directly
- Keeps commits atomic

### Learner (subagent)

Research-only subagent called by other agents via `@learner`. Returns compressed findings (max 40 lines) to conserve caller's context.

- READ-ONLY: no file edits, no bash
- Returns structured findings with sources
- Prefers code snippets over prose

## Commit Format

```
<type>: <description>

Task: <task name from plan>
```

## File Structure

```
AGENTS.md                   - This file (universal agent instructions)
CLAUDE.md                   - Claude Code specific instructions
agents.md                   - Agent reference documentation
agent-docs/                 - Shared state (all tools read/write)
.opencode/agents/           - OpenCode agent definitions
.opencode/commands/         - OpenCode slash commands
.claude/commands/           - Claude Code slash commands
.github/prompts/            - Copilot prompt files
.github/copilot-instructions.md - Copilot instructions
```
