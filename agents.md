# Agents

A lightweight, human-driven workflow system inspired by [GSD](https://github.com/gsd-build/get-shit-done). Focused on documentation maintenance and atomic commits.

## Philosophy

- **Human-driven**: Humans orchestrate, agents assist
- **Documentation-first**: State is always captured in markdown
- **Atomic commits**: Each logical change is one commit
- **Scan and sync**: Run `/document` anytime to capture drift

## Agent Definitions

### Planner

| Property | Value |
|----------|-------|
| **Name** | planner |
| **Description** | Creates and manages task plans from requirements |
| **Status** | Enabled |
| **Command** | `/plan` |

Creates structured task plans. Breaks work into atomic, committable units.

#### Configuration

```yaml
agent:
  name: planner
  enabled: true
  outputs:
    - agent-docs/PLAN.md
    - agent-docs/STATE.md
```

#### Routing

**Use when:** Starting new work, complex requirements, large tasks
**Skip when:** Task is trivial, plan already exists

#### Responsibilities

- Parse requirements into discrete tasks
- Identify dependencies between tasks
- Estimate scope and order tasks
- Update STATE.md with current plan

---

### Executor

| Property | Value |
|----------|-------|
| **Name** | executor |
| **Description** | Implements planned tasks with atomic commits |
| **Status** | Enabled |
| **Command** | `/execute` |

Implements tasks from PLAN.md. Each completed task = one atomic commit.

#### Configuration

```yaml
agent:
  name: executor
  enabled: true
  inputs:
    - agent-docs/PLAN.md
    - agent-docs/STATE.md
  outputs:
    - agent-docs/PLAN.md
    - agent-docs/STATE.md
  commit_style: atomic
```

#### Routing

**Use when:** Plan exists, task is well-scoped, ready to implement
**Skip when:** No plan, task unclear, need to explore first

#### Bounded Execution

Assumes context is complete. Does not research or re-scope.

#### Responsibilities

- Pick next task from plan
- Implement the task
- Create atomic commit on completion
- Update STATE.md with progress

---

### Reviewer

| Property | Value |
|----------|-------|
| **Name** | reviewer |
| **Description** | Reviews changes for quality and correctness |
| **Status** | Enabled |
| **Command** | `/review` |

Reviews staged or recent changes. Flags issues before they're committed.

#### Configuration

```yaml
agent:
  name: reviewer
  enabled: true
  checks:
    - code_quality
    - test_coverage
    - documentation_sync
  outputs:
    - agent-docs/STATE.md
```

#### Routing

**Use when:** After execute, before PR, spot-checking
**Skip when:** No changes, just need state sync

#### READ-ONLY

Reports issues but does not fix them.

#### Responsibilities

- Review diffs for issues
- Check that tests pass
- Verify documentation is updated
- Suggest improvements

---

### Documentor

| Property | Value |
|----------|-------|
| **Name** | documentor |
| **Description** | Scans diffs and maintains documentation state |
| **Status** | Enabled |
| **Command** | `/document` |

The core agent. Scans for uncommitted changes and updates STATE.md to reflect reality.

#### Configuration

```yaml
agent:
  name: documentor
  enabled: true
  scan:
    - git_diff
    - git_status
    - recent_commits
  outputs:
    - agent-docs/STATE.md
    - agent-docs/PLAN.md
    - agent-docs/CHANGELOG.md
```

#### Routing

**Use when:** Anytime, after manual changes, before handoff
**Skip when:** About to execute (it updates state itself)

#### CODE READ-ONLY

Only updates `agent-docs/`. Does not modify code.

#### Responsibilities

- Scan working directory for changes
- Compare reality vs documented state
- Update STATE.md with drift
- Maintain CHANGELOG.md
- Flag undocumented changes

---

## State Files

**IMPORTANT**: All state files live in `/agent-docs/` so all agent frameworks can access them.

```
agent-docs/
  STATE.md      - Current phase, in-progress work, blockers
  PLAN.md       - Task breakdown with checkboxes
  CHANGELOG.md  - Human-readable change log
```

| File | Purpose |
|------|---------|
| `agent-docs/STATE.md` | Current work state, tasks in progress, blockers |
| `agent-docs/PLAN.md` | Task breakdown with dependencies and status |
| `agent-docs/CHANGELOG.md` | Human-readable change history |

**Every agent must update `/agent-docs/` after every action.**

### Efficient Reads

State files use a **header/history** structure:
- **First 50 lines**: Actionable state (read this for quick context)
- **Below the `---`**: History/logs (read only when debugging)

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks
```

This prevents context bloat as history grows.

## Workflow

```
Human: "I want to add feature X"
    │
    ▼
/plan ──► Creates PLAN.md with tasks
    │
    ▼
/execute ──► Implements task, atomic commit
    │
    ▼
/review ──► Reviews changes
    │
    ▼
/document ──► Updates STATE.md from diffs
    │
    ▼
Human: Reviews, continues or adjusts
```

## Quick Commands

| Command | Description |
|---------|-------------|
| `/plan <requirement>` | Create or update plan |
| `/execute [task]` | Execute next or specific task |
| `/review` | Review current changes |
| `/document` | Scan diffs, update state |

## Tool Compatibility

Commands are available across multiple AI coding tools:

| Tool | Command Location | Format |
|------|------------------|--------|
| **Claude Code** | `.claude/commands/*.md` | Markdown with `$ARGUMENTS` |
| **OpenCode** | `.opencode/commands/*.md` | Markdown with YAML frontmatter |
| **Copilot Chat** | `.github/prompts/*.prompt.md` | Markdown with YAML frontmatter |

### Directory Structure

```
.claude/commands/       # Claude Code
  plan.md
  execute.md
  review.md
  document.md

.opencode/commands/     # OpenCode
  plan.md
  execute.md
  review.md
  document.md

.github/
  copilot-instructions.md   # Copilot general instructions
  prompts/                  # Copilot prompt files
    plan.prompt.md
    execute.prompt.md
    review.prompt.md
    document.prompt.md

agent-docs/             # Shared state (all tools read/write here)
  STATE.md
  PLAN.md
  CHANGELOG.md
```

### Usage by Tool

| Tool | Invocation |
|------|------------|
| Claude Code | Type `/plan`, `/execute`, `/review`, `/document` |
| OpenCode | Type `/plan`, `/execute`, `/review`, `/document` |
| Copilot Chat | Type `/plan`, `/execute`, `/review`, `/document` |

## Agent Statuses

- **Enabled** - Agent is active and available
- **Disabled** - Agent is defined but not available
- **Maintenance** - Agent is being updated
