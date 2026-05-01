---
title: OpenCode Agent YAML Frontmatter
type: concept
project: opencode-agent
tags: [concept, opencode, yaml, agents]
created: 2026-04-30T14:30:00-04:00
status: active
source: agent
session_id: opc-2026-04-30-001
source_daily: "[[2026-04-30]]"
confidence: high
related:
  - "[[concept-subagent-delegation]]"
  - "[[../decisions/2026-04-30-agentfixer-confirmation]]"
---

# OpenCode Agent YAML Frontmatter

## Required Fields

```yaml
---
description: Brief description of agent purpose
---
```

## Optional Fields

```yaml
---
mode: primary          # primary | subagent | all (default: all)
model: anthropic/claude-sonnet  # Override default model
temperature: 0.1       # 0.0-1.0, lower = more deterministic
tools:
  task: true           # Subagent delegation
  read: true           # File reading
  edit: true           # File editing
  write: true          # File creation
  bash: true           # Shell commands
  glob: true           # File pattern matching
  grep: true           # Text search
  webfetch: false      # Web fetching
permission:
  edit: ask            # allow | ask | deny
  bash: allow
  webfetch: deny
  task:
    "explorer": allow
    "*": ask
---
```

## Mode Values

| Mode | Behavior |
|------|----------|
| `primary` | Appears in agent list, user-invocable |
| `subagent` | Only invocable via `task` tool |
| `all` | Both (default) |

## Permission Values

| Value | Behavior |
|-------|----------|
| `allow` | Execute without prompting |
| `ask` | Prompt user for approval |
| `deny` | Block execution |

## Tool Permissions

Granular bash permissions:

```yaml
permission:
  bash:
    "git status": allow
    "git diff": allow
    "rm *": deny
    "*": ask
```
