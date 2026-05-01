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

### AgentFixer

Meta-agent that modifies agent instruction files across all frameworks (OpenCode, Claude Code, Copilot). Knows exact file locations.

- Prompts for frequently accessed files, URLs, MCP servers, and keywords
- Applies best practices: YAML frontmatter, permission backstops, imperative rules
- MUST ask before editing any agent file
- Delegates research to `learner` when unsure about conventions

## Obsidian Vault Integration

Vault location: `~/.obsidian/Obsidian Vault`

### Guardrails

1. **NEVER delete from `10-daily/`** — Daily notes are immutable session records
2. **NEVER edit notes older than 7 days** without explicit user instruction
3. **Low-confidence (1-4) extractions go to `00-inbox/`** — Human reviews before filing
4. **Use Obsidian CLI for writes** — Keeps metadata cache consistent (`obsidian create`, `obsidian property:set`)
5. **Always set `source: agent`** on notes you create
6. **Include `session_id` and `source_daily`** for traceability

### Commands

| Command | Purpose |
|---------|---------|
| `/note` | Store extracted knowledge to vault |
| `/daily` | Read/append to daily note |
| `/vault` | Search and query vault |

### Note Types

| Type | Location | When to use |
|------|----------|-------------|
| `concept` | `40-resources/concepts/` or `20-projects/*/concepts/` | Atomic knowledge worth keeping |
| `snippet` | `40-resources/snippets/` or `20-projects/*/snippets/` | Reusable code/config |
| `decision` | `20-projects/*/decisions/` | ADR-style decision record |
| `todo` | `20-projects/*/todos/` | Task with priority (1-10) and project linkage |

### Session Logging

Append session summaries to daily note using this format:

```markdown
## Session <session-id> — <project>

- **summary**: <one-line summary>
- **tags**: #tag1 #tag2
- **confidence**: 1-10 (10 = highest)

### Artifacts
<code snippets created>

### Decisions
<decisions made>

### Learnings
<concepts worth extracting>
```

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
