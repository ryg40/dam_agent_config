---
description: Store a note to Obsidian vault via CLI
---

# Note Store

Capture session learnings to Obsidian vault. Uses the Obsidian CLI.

## Vault Location

`~/.obsidian/Obsidian Vault`

## Usage

```
/note <content>
/note store <content>
/note concept <title> - <content>
/note snippet <title> - <content>
/note decision <title> - <content>
```

## Behavior

1. **Generate session ID**: `opc-YYYY-MM-DD-NNN`
2. **Append to daily note** under session heading:

```bash
obsidian daily:append content="
## Session $SESSION_ID — $PROJECT

- **summary**: $ARGUMENTS
- **tags**: #relevant #tags
- **confidence**: high|medium|low

### Artifacts (if any)
\`\`\`
code or config snippet
\`\`\`
"
```

3. **Set frontmatter** if creating standalone note:

```bash
obsidian create path="$PATH" content="$CONTENT"
obsidian property:set path="$PATH" name="source" value="agent"
obsidian property:set path="$PATH" name="session_id" value="$SESSION_ID"
obsidian property:set path="$PATH" name="source_daily" value="[[$(date +%Y-%m-%d)]]"
obsidian property:set path="$PATH" name="confidence" value="$CONFIDENCE"
```

## Path Resolution

| Type | Project-scoped | Global |
|------|----------------|--------|
| concept | `20-projects/$PROJECT/concepts/` | `40-resources/concepts/` |
| snippet | `20-projects/$PROJECT/snippets/` | `40-resources/snippets/` |
| decision | `20-projects/$PROJECT/decisions/` | (requires project) |

## Required Fields

Agent notes MUST include:
- `source: agent`
- `session_id`
- `source_daily`
- `confidence`

## Guardrails

- NEVER delete notes from `10-daily/` (immutable record)
- NEVER edit notes older than 7 days without user instruction
- Low-confidence extractions go to `00-inbox/` for human review
