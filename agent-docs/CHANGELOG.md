# Changelog

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
