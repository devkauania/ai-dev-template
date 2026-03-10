# Session Protocol

## How Sessions Work

Each session = one focused feature. This prevents scope creep and makes AI agents 10x more productive because they always know exactly what to do.

## Workflow

1. **Read** `CLAUDE.md` (auto-loaded) + `.context/STATE.md` (read manually)
2. **Code**: Write test first (red) → implement (green) → refactor
3. **Validate**: `make validate`
4. **Report**: Present validation table to user

## While Coding

- One feature per session, no mixing
- Test first, always
- Document new env vars in `.env.example`
- Update `.context/STATE.md` test baseline when adding tests

## Validation Checklist

```bash
# Option A: Makefile (preferred)
make validate

# Option B: Manual
make test && make lint
```

### Validation Report Template

| Area | Before | After | Status |
|------|--------|-------|--------|
| api | N | N | OK/REGRESSION |
| services | N | N | OK/REGRESSION |
| domain | N | N | OK/REGRESSION |
| **Lint** | — | — | CLEAN/ERRORS |

**If ANY regression: fix it. Do not end the session.**

## Starting a New Session

1. Open `.context/STATE.md`
2. Find the next pending session
3. Update its status to "In Progress"
4. Start coding
5. When done: run `make validate`, update test counts, mark as "Done"

## Tips for AI Agents

- Read `CLAUDE.md` first — it tells you WHERE everything is
- Read `.context/STATE.md` — it tells you WHAT to do
- Don't overthink. Follow the workflow: test → implement → validate
- Don't create branches or worktrees. Work on `master`
- Keep the preview server running
