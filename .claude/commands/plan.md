# Plan

Break requirements into atomic tasks.

## Routing

**Use when:**
- Starting new work
- Requirements are unclear or complex
- Need to break down a large task

**Skip when:**
- Task is trivial (just `/execute` directly)
- Plan already exists and is current

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks only
```

## Steps

1. Read first 50 lines of STATE.md and PLAN.md
2. Parse requirement: $ARGUMENTS
3. Break into atomic tasks (one commit each)
4. Update PLAN.md header with tasks
5. Update STATE.md header (phase: executing)

## Task Format

Reference files by path, not content:

```markdown
## Active

- [ ] **Task name** - Brief description
  - Files: `src/app.ts`, `lib/utils.ts`
  - Depends: (if any)
```

## Output

- Updated PLAN.md (tasks in Active section)
- Updated STATE.md (phase: executing)
