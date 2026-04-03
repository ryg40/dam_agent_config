# Execute

Implement next task with atomic commit.

## Routing

**Use when:**
- Plan exists with tasks
- Task is well-defined with clear scope
- Ready to implement (not research)

**Skip when:**
- No plan exists → `/plan` first
- Task is unclear → `/plan` to clarify
- Need to explore codebase → explore first, then `/execute`

## Bounded Execution

This command assumes context is complete. Do not:
- Research external docs
- Explore unfamiliar code extensively
- Plan or re-scope the task

If context is missing, stop and ask.

## Efficient Reads

```bash
head -50 agent-docs/STATE.md  # Quick context
head -50 agent-docs/PLAN.md   # Active tasks only
```

## Steps

1. Read first 50 lines of STATE.md and PLAN.md
2. Find next unchecked task (or use: $ARGUMENTS)
3. Read only the files listed in task
4. Implement the task
5. Commit: `<type>: <description>`
6. Move task to Done, update STATE.md

## Parallel Execution

If task involves multiple independent files, read/edit them in parallel.

## Output

- Code changes
- One atomic commit
- PLAN.md task → Done
- STATE.md progress updated
