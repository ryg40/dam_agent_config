# Changelog

## 2026-04-18

### Small-Model Orchestrator Refactor

- Rewrote `AGENTS.md` with numbered MUST/NEVER rules and a target-runtime section (30B–122B dense + MoE via llama-serve)
- Defined **Task Envelope** format (Goal, Files, Constraints, Stop when, Return format) — all subagent delegations use it; incomplete envelopes are refused
- Converted `.opencode/agents/plan.md` into an orchestrator that delegates all code reads to `explorer`, web research to `learner`, and implementation to `executor`
- Added `.opencode/agents/explorer.md` — read-only subagent returning ≤ 40 lines of `file:line` findings
- Hardened `.opencode/agents/execute.md` — strict envelope contract, refuses incomplete envelopes, only reads files listed
- Created `.claude/agents/` with `executor.md`, `explorer.md`, `learner.md` for Claude Code parity
- Rewrote slash commands (`.claude/commands/`, `.opencode/commands/`, `.github/prompts/`) as thin orchestrator invocations
- Updated `CLAUDE.md` with small-model operating notes (delegate aggressively, budget output tokens, no narration)
- Updated `.github/copilot-instructions.md` and `opencode.json` to reference envelope pattern

### Installer

- Added `install.sh` — copies config into target repos with `--dry-run`, `--force`, and skip-existing defaults
- Added root `.gitignore` for this repo
- Installer appends a marked `dam_agent_config` block to target `.gitignore` (idempotent)

## 2026-04-10

### OpenCode Compatibility & AGENTS.md

- Created `AGENTS.md` at repo root (universal agent instructions)
- Added `.opencode/agents/` with YAML frontmatter agent definitions (plan, execute, review, document)
- Added `.opencode/modes/` and `.opencode/skills/` directories
- Added `opencode.json` project config
- Reconciled `agents.md` as reference documentation, `AGENTS.md` as actionable rules
- Updated `CLAUDE.md` to cross-reference `AGENTS.md`
- Review agent: `edit: deny` (read-only enforced at config level)
- Document agent: code read-only constraint

### Efficient Read Pattern

- State files use header/history structure (first 50 lines = actionable)
- Commands instruct `head -50` for quick context
- Delegation routing: "Use when/Skip when" per command
- Bounded execution: `/execute` assumes context complete
- Parallel execution hints for independent operations

## 2026-04-03

### Initial Setup

- Created `agent-docs/` shared state directory
- Created STATE.md, PLAN.md, CHANGELOG.md
- Commands for Claude Code, OpenCode, and Copilot
