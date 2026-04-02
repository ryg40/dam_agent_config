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
    - PLAN.md
    - STATE.md
```

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
    - PLAN.md
    - STATE.md
  commit_style: atomic
```

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
```

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
    - STATE.md
    - CHANGELOG.md
```

#### Responsibilities

- Scan working directory for changes
- Compare reality vs documented state
- Update STATE.md with drift
- Maintain CHANGELOG.md
- Flag undocumented changes

---

## State Files

| File | Purpose |
|------|---------|
| `STATE.md` | Current work state, tasks in progress, blockers |
| `PLAN.md` | Task breakdown with dependencies and status |
| `CHANGELOG.md` | Human-readable change history |

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
