---
title: Todo Template
type: template
tags: [template]
---

---
title: <%= tp.system.prompt("Task title") %>
type: todo
project: <%= tp.system.prompt("Project name") %>
tags: [todo, <%= tp.system.prompt("Additional tags (comma-separated)") %>]
created: <%= tp.date.now("YYYY-MM-DDTHH:mm:ssZ") %>
status: active
source: <%= tp.system.suggester(["agent", "manual"], ["agent", "manual"]) %>
priority: <%= tp.system.suggester(["10 - Critical", "9 - Critical", "8 - High", "7 - High", "6 - Medium", "5 - Medium", "4 - Low", "3 - Low", "2 - Someday", "1 - Someday"], [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]) %>
due: <%= tp.system.prompt("Due date (YYYY-MM-DD or leave empty)") || "" %>
blocked_by: <%= tp.system.prompt("Blocked by (wikilink or leave empty)") || "" %>
session_id: <%= tp.system.prompt("Session ID (or leave empty)") || "" %>
source_daily: <%= tp.system.prompt("Source daily (wikilink or leave empty)") || "" %>
confidence: <%= tp.system.suggester(["10", "9", "8", "7", "6", "5", "4", "3", "2", "1"], [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]) %>
related:
  - 
---

# <%= tp.file.title %>

## Description

<% tp.system.prompt("Task description") %>

## Acceptance Criteria

- [ ] 

## Notes

