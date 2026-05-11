---
title: OpenCode Subagent Delegation
type: concept
area: ai-tooling
tags: [concept, opencode, agents, delegation]
created: 2026-04-30T14:45:00-04:00
status: active
source: agent
session_id: opc-2026-04-30-001
source_daily: "[[2026-04-30]]"
confidence: 9
related:
  - "[[../../20-projects/opencode-agent/concepts/concept-agent-frontmatter]]"
---

# OpenCode Subagent Delegation

How primary agents invoke subagents in OpenCode.

## Mechanism

Subagents are invoked via the `task` tool, NOT just `@` mentions.

```yaml
# Primary agent needs:
tools:
  task: true

# Subagent needs:
mode: subagent
```

## Invocation Pattern

From primary agent prompt:

```
Use the task tool to delegate to the learner subagent:
- agent: "learner"
- prompt: "Your self-contained research question here"
```

## Key Points

1. **Prompts must be self-contained** — subagent has no access to parent conversation
2. **Parallel delegation** — multiple `task` calls in single message for independent work
3. **Hidden subagents** — use `hidden: true` to hide from `@` autocomplete
4. **Permission control** — use `permission.task` to restrict which subagents can be invoked

## Permission Control

```yaml
permission:
  task:
    "learner": allow
    "explorer": allow
    "*": deny
```

## Related

- [[../../20-projects/opencode-agent/concepts/concept-agent-frontmatter]]
