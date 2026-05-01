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
type: concept                               # Required: daily|session|concept|snippet|decision|reference|project
project: project-name                       # Required if type ∈ {decision, snippet, session}
area: area-name                             # Required if no project
tags: [tag1, tag2]                          # Required
created: 2026-04-30T14:23:00-04:00          # Required
modified: 2026-04-30T14:23:00-04:00         # Optional, auto-updated
status: active                              # Required: draft|active|archived
source: agent                               # Required: agent|manual|imported
session_id: opc-2026-04-30-001              # Required for agent notes
source_daily: "[[2026-04-30]]"              # Required for agent notes
confidence: high                            # Required for agent notes: low|medium|high
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

## Confidence Values

| Value | Meaning |
|-------|---------|
| `high` | Agent confident, auto-file |
| `medium` | Mostly confident, may need review |
| `low` | Uncertain, goes to `00-inbox/` |
