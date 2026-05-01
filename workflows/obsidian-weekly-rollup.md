# Obsidian Weekly Rollup Workflow

Sunday cron job to generate weekly summary note.

## Schedule

```cron
0 22 * * 0 /path/to/weekly-rollup.sh
```

## Script: weekly-rollup.sh

```bash
#!/bin/bash
set -euo pipefail

# Load local configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/obsidian-config.sh"
check_config

VAULT="$OBSIDIAN_VAULT"
YEAR=$(date +%Y)
MONTH=$(date +%m)
WEEK=$(date +%V)
WEEK_FILE="10-daily/${YEAR}/${MONTH}/${YEAR}-W${WEEK}.md"

# Calculate week boundaries
WEEK_START=$(date -d "last monday" +%Y-%m-%d)
WEEK_END=$(date -d "next sunday" +%Y-%m-%d)

# Create weekly rollup note
cat > "/tmp/weekly-rollup.md" << EOF
---
title: ${YEAR}-W${WEEK} Weekly Rollup
type: weekly
tags: [weekly, rollup]
created: $(date -Iseconds)
week: ${WEEK}
year: ${YEAR}
---

# ${YEAR}-W${WEEK} Weekly Rollup

Week of ${WEEK_START} to ${WEEK_END}

## Sessions This Week

\`\`\`dataview
TABLE title, session_id, confidence
FROM "10-daily"
WHERE type = "daily" AND file.cday >= date(${WEEK_START}) AND file.cday <= date(${WEEK_END})
SORT file.cday ASC
\`\`\`

## Decisions Made

\`\`\`dataview
TABLE title, project, confidence, source_daily
FROM "20-projects"
WHERE type = "decision" AND file.cday >= date(${WEEK_START}) AND file.cday <= date(${WEEK_END})
SORT file.cday DESC
\`\`\`

## Snippets Added

\`\`\`dataview
LIST
FROM "20-projects" OR "40-resources/snippets"
WHERE type = "snippet" AND file.cday >= date(${WEEK_START})
SORT file.cday DESC
\`\`\`

## Concepts with Growing Backlinks

\`\`\`dataview
TABLE length(file.inlinks) AS "Backlinks"
FROM "40-resources/concepts" OR "20-projects"
WHERE type = "concept" AND length(file.inlinks) >= 3
SORT length(file.inlinks) DESC
LIMIT 5
\`\`\`

## High Priority Todos

\`\`\`dataview
TABLE project, priority, due, status
FROM "20-projects"
WHERE type = "todo" AND status != "done" AND priority >= 7
SORT priority DESC
\`\`\`

## Blocked Todos

\`\`\`dataview
TABLE project, blocked_by, priority
FROM "20-projects"
WHERE type = "todo" AND status = "blocked"
SORT priority DESC
\`\`\`

## Review Queue

- [ ] Review low-confidence notes in 00-inbox/
- [ ] Check orphaned notes
- [ ] Resolve broken links
- [ ] Tag hygiene audit
EOF

# Create the note
obsidian create path="$WEEK_FILE" content="$(cat /tmp/weekly-rollup.md)"

# Run hygiene checks
echo "=== Weekly Hygiene Report ==="
echo ""
echo "Orphaned notes:"
obsidian orphans
echo ""
echo "Unresolved links:"
obsidian unresolved
echo ""
echo "Tags with <3 uses:"
obsidian tags counts sort=count | head -20

# Git commit (if enabled)
if [ "$GIT_AUTO_COMMIT" = "true" ]; then
  cd "$VAULT"
  git add -A
  git commit -m "${GIT_COMMIT_PREFIX} Weekly rollup: ${YEAR}-W${WEEK}" || true
fi

rm /tmp/weekly-rollup.md
```

## Output

Creates `10-daily/YYYY/MM/YYYY-WNN.md` with:

1. **Sessions This Week** — Dataview table of daily notes
2. **Decisions Made** — Project decisions from the week
3. **Snippets Added** — New code snippets
4. **Concepts with Backlinks** — Notes gaining traction
5. **High Priority Todos** — Priority 7-10 todos
6. **Blocked Todos** — Todos waiting on dependencies
7. **Review Queue** — Hygiene tasks

## Hygiene Checks

- Orphaned notes (no incoming/outgoing links)
- Unresolved wikilinks (broken references)
- Underused tags (<3 uses, candidates for consolidation)
