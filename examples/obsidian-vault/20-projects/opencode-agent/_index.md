---
title: OpenCode Agent Configuration
type: project
tags: [opencode, agents, meta, project]
created: 2026-04-28T10:00:00-04:00
status: active
---

# OpenCode Agent Configuration

Project MOC for the dam_agent_config repository.

## Overview

Lightweight, human-driven workflow system for AI coding agents. Configuration and documentation repository supporting:

- **OpenCode**: `.opencode/agents/`, `.opencode/commands/`
- **Claude Code**: `.claude/commands/`
- **Copilot Chat**: `.github/prompts/`

## Todos

```dataview
TABLE priority, status, due
FROM "20-projects/opencode-agent/todos"
WHERE type = "todo" AND status != "done"
SORT priority DESC
```

## Active Work

```dataview
TASK
FROM "20-projects/opencode-agent"
WHERE !completed
```

## Recent Decisions

```dataview
TABLE title, created, confidence
FROM "20-projects/opencode-agent/decisions"
SORT created DESC
LIMIT 5
```

## Key Concepts

- [[concept-agent-frontmatter]] — YAML frontmatter fields for OpenCode agents
- [[concept-subagent-delegation]] — Using the task tool for subagent invocation
- [[concept-efficient-reads]] — head -50 pattern for state files

## Key Snippets

- [[snippet-agent-template]] — Base template for new agents
- [[snippet-curl-sync]] — Sync agents from GitHub to local config

## Links

- [GitHub Repo](https://github.com/ryg40/dam_agent_config)
- [[../homelab-inference/_index|Homelab Inference Project]]
