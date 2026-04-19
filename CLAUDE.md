# CLAUDE.md

Claude Code specific notes. Universal rules for all agents live in [AGENTS.md](AGENTS.md) — read that first.

## Target Runtime

This repo's agent configuration is tuned for **small local models** served via llama-serve (typical pairing: two ~35B models loaded at Q8 with ~120k context). See AGENTS.md "Target Runtime" for the full list.

Claude Code is supported too, but the defaults (short responses, aggressive delegation, tight envelopes) are calibrated for the local-model case. Claude Code will naturally be within budget.

## Operating Notes for Small Models

Apply these whether the backing model is Claude or a local 30–122B:

1. **Delegate aggressively.** The orchestrator should never glob, grep, or read source files itself. That's `explorer`'s job.
2. **Envelopes are mandatory.** Every subagent call uses the Task Envelope format from AGENTS.md. Refuse incomplete envelopes — don't guess.
3. **Reasoning stays internal.** Do not stream chain-of-thought. Emit only tool calls and terse user-facing messages.
4. **Budget output tokens.** Orchestrator messages ≤ 100 words; subagent returns ≤ 40 lines.
5. **No restating.** Don't echo the user's request or narrate what you are about to do.

## Repository Structure

```
AGENTS.md                         Universal rules (primary source)
CLAUDE.md                         This file
agents.md                         Reference documentation
opencode.json                     OpenCode project config
agent-docs/                       Shared state
.claude/agents/                   Subagent definitions (Claude Code)
.claude/commands/                 Slash commands (Claude Code)
.opencode/agents/                 Agent definitions (OpenCode)
.opencode/commands/               Slash commands (OpenCode)
.github/prompts/                  Copilot prompt files
.github/copilot-instructions.md   Copilot rules
```

## Subagents

Claude Code's Task tool can invoke the subagents defined in `.claude/agents/`:

| Subagent | Purpose | Tools |
|----------|---------|-------|
| `executor` | Implement one Task Envelope, commit | Read, Edit, Write, Bash |
| `explorer` | Read-only code exploration, ≤40 line return | Read, Glob, Grep |
| `learner` | Web research, ≤40 line return | WebFetch, WebSearch, Read |

Invoke via the Task tool with `subagent_type` matching the filename.

## Commands

| Command | Purpose |
|---------|---------|
| `/plan <req>` | Orchestrator plans and delegates |
| `/execute [task]` | Orchestrator delegates next task to `executor` |
| `/review` | Read-only diff review |
| `/document` | Sync `agent-docs/` to match git reality |

## Commit Style

```
<type>: <description>

Task: <task name from plan>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`.

## Git Workflow

- Branch prefix `claude/` for automated branches
- Atomic commits per task
- Changes merged via PR
