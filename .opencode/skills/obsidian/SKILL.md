# Obsidian CLI Skill

Interact with Obsidian vaults via the official CLI. Requires Obsidian v1.12+ running.

## Vault Location

Default vault: `~/.obsidian/Obsidian Vault`

Override with `vault="Name"` as first parameter.

## Command Reference

### Daily Notes

```bash
obsidian daily                              # Open today's daily note
obsidian daily:read                         # Print today's note content
obsidian daily:append content="..."         # Append to today's note
obsidian daily:prepend content="..."        # Prepend to today's note
```

### Note Operations

```bash
obsidian read path="folder/note.md"         # Read a note
obsidian read file="Note Name"              # Read by wikilink name
obsidian create name="Note" content="..."   # Create note
obsidian create path="folder/note" template="template-name"
obsidian append path="note.md" content="..."
obsidian prepend path="note.md" content="..."
obsidian move from="old/path.md" to="new/path.md"
obsidian delete path="note.md"              # Move to trash
```

### Search & Query

```bash
obsidian search query="term" format=json    # Vault search
obsidian search query="term" limit=10       # Limit results
obsidian backlinks file="Note"              # Notes linking to this
obsidian outlinks file="Note"               # Notes this links to
obsidian orphans                            # Notes with no links
obsidian unresolved                         # Broken wikilinks
```

### Properties (Frontmatter)

```bash
obsidian property:set path="note.md" name="status" value="active"
obsidian property:get path="note.md" name="status"
obsidian property:delete path="note.md" name="old-field"
```

### Tags & Tasks

```bash
obsidian tags                               # All tags
obsidian tags counts sort=count             # Tag frequency
obsidian tasks                              # All open tasks
obsidian tasks completed=true               # Completed tasks
```

### File Management

```bash
obsidian files sort=modified limit=5        # Recent files
obsidian files folder="20-projects"         # Files in folder
obsidian open path="note.md"                # Open in Obsidian
```

### Plugin Development

```bash
obsidian plugin:reload id="plugin-id"       # Reload plugin
obsidian dev:errors                         # Check for errors
obsidian dev:console level=error            # Console output
obsidian eval code="app.vault.getFiles().length"  # Run JS
```

## Parameter Syntax

- Use `=` notation: `name="value"`
- Quote values with spaces: `content="Hello world"`
- Boolean flags standalone: `silent`, `completed=true`
- Wikilink resolution: `file="Note Name"` (no extension)
- Path resolution: `path="folder/note.md"` (from vault root)

## Performance Notes

CLI is ~70,000× cheaper than reading files via MCP for graph operations:
- Orphan detection: 15.6s → 0.26s
- Vault search: 1.95s → 0.32s

## Caveats

- Requires Obsidian to be running
- No daemon mode yet
- For headless servers: run in LXC with xvfb
