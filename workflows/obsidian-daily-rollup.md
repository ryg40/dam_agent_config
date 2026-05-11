# Obsidian Daily Rollup Workflow

End-of-day cron job to extract structured notes from daily log.

## Schedule

```cron
0 23 * * * /path/to/daily-rollup.sh
```

## Script: daily-rollup.sh

```bash
#!/bin/bash
set -euo pipefail

# Load local configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/obsidian-config.sh"
check_config

VAULT="$OBSIDIAN_VAULT"
TODAY=$(date +%Y-%m-%d)
DAILY_NOTE="10-daily/$(date +%Y)/$(date +%m)/${TODAY}.md"

# 1. Read today's daily note
RAW=$(obsidian daily:read)

if [ -z "$RAW" ]; then
  echo "No daily note for $TODAY"
  exit 0
fi

# 2. Extract items using local model (pseudocode)
# This would call your local LLM to parse the daily note
# Returns JSON array of {type, title, project, tags, content, session_id, confidence}

# Example using a hypothetical extraction script:
# ITEMS=$(echo "$RAW" | python3 extract_items.py)

# 3. For each extracted item, create note in appropriate location
# 
# Pseudocode:
# for item in items:
#   match item.type:
#     case "concept" if item.project:
#       path = "20-projects/${item.project}/concepts/${slug(item.title)}.md"
#     case "concept":
#       path = "40-resources/concepts/${slug(item.title)}.md"
#     case "snippet" if item.project:
#       path = "20-projects/${item.project}/snippets/${slug(item.title)}.md"
#     case "snippet":
#       path = "40-resources/snippets/${slug(item.title)}.md"
#     case "decision":
#       path = "20-projects/${item.project}/decisions/${TODAY}-${slug(item.title)}.md"
#   
#   if [ "$item.confidence" -lt "$CONFIDENCE_THRESHOLD" ]; then
#     path = "00-inbox/${slug(item.title)}.md"
#   fi
#   
#   obsidian create path="$path" content="$item.content"
#   obsidian property:set path="$path" name="source" value="agent"
#   obsidian property:set path="$path" name="session_id" value="$item.session_id"
#   obsidian property:set path="$path" name="source_daily" value="[[${TODAY}]]"
#   obsidian property:set path="$path" name="confidence" value="$item.confidence"

# 4. Check for issues
echo "Checking for unresolved links..."
obsidian unresolved

# 5. Git commit (if enabled)
if [ "$GIT_AUTO_COMMIT" = "true" ]; then
  cd "$VAULT"
  git add -A
  git commit -m "${GIT_COMMIT_PREFIX} Daily rollup: $TODAY" || true
fi
```

## Extraction Schema

The extraction model should return:

```json
[
  {
    "type": "concept|snippet|decision|todo",
    "title": "Note title",
    "project": "project-name or null",
    "tags": ["tag1", "tag2"],
    "content": "Note content in markdown",
    "session_id": "opc-2026-04-30-001",
    "confidence": 8,
    "priority": 7
  }
]
```

## Guardrails

- NEVER delete from `10-daily/` (immutable)
- NEVER edit notes older than 7 days
- Low-confidence items (< `$CONFIDENCE_THRESHOLD`) → `00-inbox/`
- Git commit after rollup (if `git.auto_commit: true`)
