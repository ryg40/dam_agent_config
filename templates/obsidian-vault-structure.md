# Obsidian Vault Structure

PARA + Johnny-Decimal hybrid. Lowercase kebab-case throughout.

## Directory Layout

```
~/.obsidian/Obsidian Vault/
├── 00-inbox/                          # Unprocessed captures, agent dumps
├── 10-daily/                          # Raw daily notes (immutable record)
│   └── 2026/
│       └── 04/
│           ├── 2026-04-30.md          # daily note
│           └── 2026-W18.md            # weekly rollup
├── 20-projects/                       # Active work with finish lines
│   ├── project-name/
│   │   ├── _index.md                  # Project MOC (folder note)
│   │   ├── decisions/                 # ADR-style decisions
│   │   ├── concepts/                  # Project-specific knowledge
│   │   └── snippets/                  # Project-specific code
├── 30-areas/                          # Ongoing responsibilities
│   ├── homelab-ops/
│   ├── ai-tooling/
│   └── networking/
├── 40-resources/                      # Evergreen reference
│   ├── concepts/                      # Atomic notes (Zettelkasten)
│   ├── snippets/                      # Reusable code
│   └── references/                    # External docs, links
├── 50-archive/                        # Done projects
├── 90-meta/
│   ├── templates/                     # Templater templates
│   ├── _moc.md                        # Master Map of Content
│   ├── tag-taxonomy.md                # Authoritative tag list
│   └── schema.md                      # Frontmatter schema
└── .obsidian/                         # Obsidian config
```

## Frontmatter Schema

```yaml
---
title: Note title
type: concept            # daily|session|concept|snippet|decision|reference|project
project: project-name    # Required for decisions/snippets in projects
area: area-name          # Required when no project
tags: [tag1, tag2]
created: 2026-04-30T14:23:00-04:00
modified: 2026-04-30T14:23:00-04:00
status: active           # draft|active|archived
source: agent            # agent|manual|imported
session_id: opc-2026-04-30-001
source_daily: "[[2026-04-30]]"
confidence: high         # low|medium|high
related:
  - "[[other-note]]"
---
```

## Required Fields

**All notes**: `title`, `type`, `tags`, `created`, `source`

**Agent-generated**: add `session_id`, `source_daily`, `confidence`

**Project-scoped**: add `project`

**Area-scoped**: add `area` (when no project)

## Tag Taxonomy

**Domain**: `#ai-inference` `#docker` `#proxmox` `#networking` `#storage` `#observability`

**Type**: `#decision` `#snippet` `#concept` `#troubleshoot` `#postmortem` `#reference`

**Status**: `#wip` `#blocked` `#done` `#deprecated`

**Tool**: `#opencode` `#vllm` `#obsidian` `#frigate` `#caddy`
