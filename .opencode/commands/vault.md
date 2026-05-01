---
description: Search and query Obsidian vault
---

# Vault Search

Search and query the Obsidian vault.

## Vault Location

`~/.obsidian/Obsidian Vault`

## Usage

```
/vault search <query>     # Full-text search
/vault tags               # List all tags with counts
/vault orphans            # Notes with no links
/vault recent             # Recently modified notes
/vault tasks              # Open tasks
```

## Commands

### Full-text search

```bash
obsidian search query="$ARGUMENTS" format=json limit=10
```

### Tag operations

```bash
obsidian tags counts sort=count           # All tags by frequency
obsidian search query="tag:#decision"     # Notes with specific tag
```

### Link analysis

```bash
obsidian backlinks file="Note Name"       # What links to this
obsidian outlinks file="Note Name"        # What this links to
obsidian orphans                          # Unlinked notes
obsidian unresolved                       # Broken wikilinks
```

### Recent files

```bash
obsidian files sort=modified limit=10
obsidian files folder="20-projects" sort=modified limit=5
```

### Tasks

```bash
obsidian tasks                            # All open tasks
obsidian tasks completed=true             # Completed tasks
```

## Output Format

For agent consumption, use `format=json` to get structured results:

```bash
obsidian search query="vllm tensor parallel" format=json
```

## Common Queries

### Find decisions for a project

```bash
obsidian search query="type:decision project:homelab-inference" format=json
```

### Find recent agent-generated notes

```bash
obsidian search query="source:agent" format=json limit=20
```

### Find low-confidence notes needing review

```bash
obsidian search query="confidence:low" format=json
```
