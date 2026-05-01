---
title: Frontmatter Schema
type: meta
tags: [meta, schema, frontmatter]
created: 2026-04-28T10:00:00-04:00
status: active
---

# Frontmatter Schema

Contract between human, agent, Dataview, and MCP clients.

## Full Schema

```yaml
---
title: Note title                           # Required
type: concept                               # Required: daily|session|concept|snippet|decision|reference|project|todo
project: project-name                       # Required if type ∈ {decision, snippet, session, todo}
area: area-name                             # Required if no project
tags: [tag1, tag2]                          # Required
created: 2026-04-30T14:23:00-04:00          # Required
modified: 2026-04-30T14:23:00-04:00         # Optional, auto-updated
status: active                              # Required: draft|active|archived|done|blocked
source: agent                               # Required: agent|manual|imported
session_id: opc-2026-04-30-001              # Required for agent notes
source_daily: "[[2026-04-30]]"              # Required for agent notes
confidence: 8                               # Required for agent notes: 1-10 (10 = highest)
priority: 7                                 # Required for todos: 1-10 (10 = highest)
due: 2026-05-15                             # Optional for todos
blocked_by: "[[other-todo]]"                # Optional for todos
related:                                    # Optional
  - "[[other-note]]"
---
```

## Required Fields by Source

### All Notes

- `title`
- `type`
- `tags`
- `created`
- `source`

### Agent-Generated Notes

Add:
- `session_id`
- `source_daily`
- `confidence`

### Project-Scoped Notes

Add:
- `project`

### Area-Scoped Notes

Add:
- `area` (when no project applies)

## Type Values

| Type | Description | Location |
|------|-------------|----------|
| `daily` | Daily note | `10-daily/` |
| `session` | Session summary | Embedded in daily |
| `concept` | Atomic knowledge | `*/concepts/` |
| `snippet` | Reusable code | `*/snippets/` |
| `decision` | ADR record | `*/decisions/` |
| `reference` | External link | `40-resources/references/` |
| `project` | Project MOC | `20-projects/*/_index.md` |
| `todo` | Task/action item | `20-projects/*/todos/` |

## Confidence Scale (1-10)

| Value | Meaning |
|-------|---------|
| `8-10` | Agent confident, auto-file |
| `5-7` | Mostly confident, may need review |
| `1-4` | Uncertain, goes to `00-inbox/` |

## Priority Scale (1-10)

| Value | Meaning |
|-------|---------|
| `9-10` | Critical, do immediately |
| `7-8` | High priority, this week |
| `5-6` | Medium priority, this sprint |
| `3-4` | Low priority, backlog |
| `1-2` | Nice to have, someday |

## Todo Fields

| Field | Required | Description |
|-------|----------|-------------|
| `priority` | Yes | 1-10 ranking (10 = highest) |
| `due` | No | Due date (YYYY-MM-DD) |
| `blocked_by` | No | Wikilink to blocking todo |
| `project` | Yes | Project this todo belongs to |
