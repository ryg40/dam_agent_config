# State

<!-- EFFICIENT READ: First 50 lines contain all actionable state -->

**Phase**: planning
**Updated**: 2026-04-10
**Progress**: 0/7

## Focus

Configure repo for OpenCode compatibility and AGENTS.md enforcement.

## Blocked

(none)

## Next

Execute task 1: Create AGENTS.md at repo root.

---
<!-- CONTEXT BELOW: Read only when needed -->

## Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-04-10 | Create AGENTS.md alongside CLAUDE.md | AGENTS.md is the universal standard; OpenCode uses it over CLAUDE.md |
| 2026-04-10 | Keep agents.md as reference doc | AGENTS.md gets actionable rules; agents.md stays as detailed documentation |
| 2026-04-10 | Use YAML frontmatter for OpenCode agents | OpenCode convention; enables permissions, model selection |
| 2026-04-10 | Review/document agents get edit:deny | Read-only constraint enforced at config level, not just prompt level |

## Session Log

| Date | Action | Outcome |
|------|--------|---------|
| 2026-04-03 | init | Created state files |
| 2026-04-10 | plan | 7 tasks for OpenCode + AGENTS.md config |
