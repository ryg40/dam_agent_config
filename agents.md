# Agents

Reference documentation for all agents in this repo. For actionable rules, see [AGENTS.md](AGENTS.md). For small-model operating notes, see [CLAUDE.md](CLAUDE.md).

## Architecture

This repo uses an **orchestrator / executor split** tuned for local models (30B–122B served via llama-serve). The orchestrator plans and delegates; subagents do the tool calls. Two models can be loaded simultaneously — one hosts the orchestrator, one rotates through subagent invocations.

```
user → planner (orchestrator)
         ├── explorer   (read-only codebase search)
         ├── learner    (web research)
         └── executor   (one task, one commit)
```

## Primary Agents

### planner (`/plan`)

Orchestrator. Breaks requirements into atomic tasks. Delegates all code reads to `explorer`, all web research to `learner`, all implementation to `executor`. Writes only to `agent-docs/`.

- File: `.opencode/agents/plan.md`
- Tools: task, read/edit/write/bash for state files only
- Permissions: `edit: allow`, `bash: ask`, `webfetch: deny`

### reviewer (`/review`)

Read-only diff review. Reports issues as `path:line — description`. Never fixes.

- File: `.opencode/agents/review.md`
- Permissions: `edit: deny`, `bash: ask`, `webfetch: deny`

### documentor (`/document`)

Syncs `agent-docs/` with git reality. Code read-only — only writes to `agent-docs/`.

- File: `.opencode/agents/document.md`
- Permissions: `edit: allow` (state files), `bash: ask`, `webfetch: deny`

### oneoff

Ad-hoc planner+executor for work outside the `/plan → /execute` workflow. Does not touch `agent-docs/`. Delegates research to `learner`.

- File: `.opencode/agents/oneoff.md`
- Permissions: `edit: ask`, `bash: ask`, `webfetch: deny`

### agentfixer

Meta-agent that modifies agent instruction files across frameworks (OpenCode, Claude Code, Copilot).

- File: `.opencode/agents/agentfixer.md`
- Permissions: `edit: ask`, `bash: deny`, `webfetch: deny`

## Subagents

### executor

Implements one Task Envelope and commits. Refuses incomplete envelopes. Only reads files listed in the envelope.

- File: `.opencode/agents/execute.md` / `.claude/agents/executor.md`
- Tools: read, edit, write, bash (no glob/grep/web)
- Invoked by: planner, oneoff

### explorer

Read-only codebase exploration. Returns ≤ 40 lines of `file:line` findings.

- File: `.opencode/agents/explorer.md` / `.claude/agents/explorer.md`
- Tools: read, glob, grep (no edit/bash/web)
- Invoked by: planner, executor (when envelope needs files resolved)

### learner

Web research subagent. Returns ≤ 40 lines with source URLs.

- File: `.opencode/agents/learner.md` / `.claude/agents/learner.md`
- Tools: webfetch, websearch, read (no edit/bash)
- Invoked by: planner, oneoff, agentfixer

## Task Envelope

All delegations use the envelope defined in AGENTS.md:

```markdown
## Task Envelope
**Goal:** <one sentence, imperative>
**Files:** `path/a.ts`, `path/b.ts`
**Constraints:** <must/never>
**Stop when:** <observable condition>
**Return format:** <expected shape>
```

Subagents MUST refuse with `ENVELOPE INCOMPLETE: <missing>` rather than guess.

## State Files

| File | Purpose |
|------|---------|
| `agent-docs/STATE.md` | Phase, focus, blockers. First 50 lines = actionable. |
| `agent-docs/PLAN.md` | Task breakdown with checkboxes. First 50 lines = active. |
| `agent-docs/CHANGELOG.md` | Append-only history. |

## Commands

| Command | Agent | Purpose |
|---------|-------|---------|
| `/plan <req>` | planner | Orchestrator plans + delegates |
| `/execute [task]` | planner → executor | Delegate next task |
| `/review` | reviewer | Read-only diff review |
| `/document` | documentor | Sync state to git reality |

## Tool Compatibility

| Framework | Agents | Commands/Prompts | Rules |
|-----------|--------|------------------|-------|
| OpenCode | `.opencode/agents/*.md` | `.opencode/commands/*.md` | `AGENTS.md` |
| Claude Code | `.claude/agents/*.md` | `.claude/commands/*.md` | `CLAUDE.md` + `AGENTS.md` |
| Copilot Chat | — | `.github/prompts/*.prompt.md` | `.github/copilot-instructions.md` |

## Installer

Drop this config into another repo with:

```bash
./install.sh /path/to/target-repo        # skip existing files
./install.sh /path/to/target-repo --force  # overwrite
```

See `install.sh` for details.
