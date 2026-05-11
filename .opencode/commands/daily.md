---
description: Interact with today's Obsidian daily note
---

# Daily Note

Read, append, or manage today's daily note.

## Vault Location

`~/.obsidian/Obsidian Vault`

## Usage

```
/daily              # Read today's daily note
/daily read         # Same as above
/daily append       # Append content (prompts for input)
/daily sessions     # List session headings from today
```

## Commands

### Read today's note

```bash
obsidian daily:read
```

### Append to today's note

```bash
obsidian daily:append content="
## Session opc-$(date +%Y-%m-%d)-001 — project-name

- **summary**: Brief description of work done
- **tags**: #tag1 #tag2
- **confidence**: high

### Artifacts
\`\`\`yaml
# config snippet
\`\`\`
"
```

### List recent daily notes

```bash
obsidian files folder="10-daily/$(date +%Y)/$(date +%m)" sort=modified limit=7
```

## Session Format

Each session block in daily note:

```markdown
## Session opc-2026-04-30-001 — project-name

- **summary**: What was accomplished
- **tags**: #domain #type #tool
- **confidence**: high|medium|low

### Artifacts
(code snippets, configs, commands)

### Decisions
(any decisions made with rationale)

### Learnings
(concepts worth extracting later)
```

## Guardrails

- Daily notes in `10-daily/` are immutable records
- NEVER delete content from daily notes
- NEVER edit daily notes older than 7 days
- Append only, preserve chronological order
