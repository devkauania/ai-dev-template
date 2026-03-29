# Session Protocol

## How Sessions Work

Each session = one focused feature. This prevents scope creep and makes AI agents dramatically more productive because they always know exactly what to do.

## Workflow

1. **Read** `CLAUDE.md` (auto-loaded) + `.context/STATE.md` (read manually)
2. **Code**: Write test first (red), implement (green), refactor
3. **Validate**: `make validate`
4. **Report**: Update STATE.md with new test counts

## While Coding

- One feature per session, no mixing
- Test first, always
- Document new env vars in `.env.example`
- Update `.context/STATE.md` test baseline when adding tests
- Don't add features, docstrings, or "improvements" beyond what was asked

## Validation Checklist

```bash
make validate
```

### Validation Report Template

| Area | Before | After | Status |
|------|--------|-------|--------|
| api | N | N | OK/REGRESSION |
| services | N | N | OK/REGRESSION |
| domain | N | N | OK/REGRESSION |
| **Lint** | — | — | CLEAN/ERRORS |

**If ANY regression: fix it. Do not end the session.**

## Protection Hooks

The template includes 5 hookify rules that activate automatically:

| Hook | Trigger | Action |
|------|---------|--------|
| `validate-before-stop` | Agent wants to stop | Reminds validation checklist |
| `credential-protection` | Writing secrets to non-.env files | Warns about hardcoded credentials |
| `dangerous-commands` | rm -rf /, force push, DROP TABLE | **Blocks** the command |
| `env-safety` | Editing .env files | Reminds .env rules (no inline comments) |
| `branch-protection` | git checkout -b, git worktree | Explains master-only policy |

## Starting a New Session

1. Open `.context/STATE.md`
2. Find the next pending session
3. Update its status to "In Progress"
4. Start coding
5. When done: run `make validate`, update test counts, mark as "Done"

## Tips for AI Agents

- Read `CLAUDE.md` first — it tells you WHERE everything is
- Read `.context/STATE.md` — it tells you WHAT to do
- Don't overthink. Follow: test, implement, validate
- Don't create branches or worktrees. Work on `master`
- Keep the preview server running
- Estimate time based on AI workflow (~15min per feature), not human dev time
