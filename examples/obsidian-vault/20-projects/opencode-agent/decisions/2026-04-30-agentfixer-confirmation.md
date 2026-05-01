---
title: AgentFixer requires confirmation before editing
type: decision
project: opencode-agent
tags: [decision, agents, safety]
created: 2026-04-30T14:00:00-04:00
status: active
source: agent
session_id: opc-2026-04-30-001
source_daily: "[[2026-04-30]]"
confidence: high
---

# AgentFixer requires confirmation before editing

## Context

AgentFixer is a meta-agent that modifies other agent instruction files. Since it can change agent behavior across all frameworks (OpenCode, Claude Code, Copilot), we need guardrails.

## Decision

AgentFixer MUST:

1. Ask clarifying questions in first response before any edits
2. Use `edit: ask` permission (mechanical backstop)
3. Propose changes and wait for approval before applying

## Rationale

- Agent modifications affect all future conversations
- Mistakes are hard to detect until agent misbehaves
- Belt-and-suspenders: prompt rule + permission setting

## Consequences

- Slower workflow (confirmation required)
- Safer modifications (no accidental changes)
- Clear audit trail (user must approve)

## Related

- [[concept-agent-frontmatter]]
- [[../snippets/snippet-agent-template]]
