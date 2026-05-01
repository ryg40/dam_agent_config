---
title: Session Summary Template
type: template
tags: [template]
---

## Session <%= tp.date.now("opc-YYYY-MM-DD") %>-NNN — <%= tp.system.prompt("Project name") %>

- **summary**: <%= tp.system.prompt("Brief summary") %>
- **tags**: #<%= tp.system.prompt("Tags (space-separated)").split(" ").join(" #") %>
- **confidence**: <%= tp.system.suggester(["high", "medium", "low"], ["high", "medium", "low"]) %>

### Artifacts

```
<% tp.system.prompt("Code/config snippet (or leave empty)") %>
```

### Decisions

<% tp.system.prompt("Decisions made (or 'none')") %>

### Learnings

<% tp.system.prompt("Concepts worth extracting (or 'none')") %>
