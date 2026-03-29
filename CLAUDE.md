# {{PROJECT_NAME}} — AI Agent Navigation Guide

> Read this FIRST. Then read `.context/STATE.md` for current session.

## Project Identity

**{{PROJECT_NAME}}** — {{ONE_LINE_DESCRIPTION}}
<!-- Example: "A low-latency API gateway for RevOps" -->
<!-- Example: "WhatsApp AI chatbot for event venues" -->

## Critical Rules

1. **Zero regressions**: If a passing test now fails, fix it before session ends.
2. **One feature per session**: Don't mix unrelated features.
3. **No worktrees/branches**: All work happens directly on `master`.
4. **Same chat**: Continue in the current conversation. Only start a new chat if context becomes too large.
5. **Preview always on**: Keep a preview server running during development via `.claude/launch.json`.
6. **Test first**: Write the test, make it pass, refactor.
7. **Null fallback**: Every service gets a `NullXxxService`. Feature flags control activation.
8. **Time estimates**: Based on actual AI-assisted workflow — tasks a solo dev does in 4h we do in ~15min.
9. **No .env inline comments**: python-dotenv reads `KEY=value # comment` as `value # comment`.

<!-- Add your own project-specific rules here -->

## Quick Commands

```bash
make install          # Install all dependencies
make test             # Run ALL tests
make lint             # Linter check
make format           # Auto-format code
make validate         # Full: tests + lint (run before ending session)
make clean            # Remove caches
```

## End-of-Session Validation

Run `make validate`. If regressions found, fix before ending.
The `validate-before-stop` hook will remind you automatically.

## Current Status

See `.context/STATE.md` for session progress, test counts, and what's next.

## Where to Modify

<!-- Map common tasks to file locations — this is the MOST IMPORTANT section -->
<!-- The AI agent uses this table to know WHERE to make changes -->
<!-- Customize this for your project structure -->

| I need to... | Files | Tests |
|---|---|---|
| Add an API route | `src/api/routes/` | `tests/api/` |
| Add a service | `src/services/` | `tests/services/` |
| Add a domain entity | `src/domain/entities/` | `tests/domain/` |
| Add a repository | `src/domain/repos/` (abstract) + `src/infra/` (impl) | `tests/infra/` |
| Add env var | `.env.example` + `src/settings.py` | — |
| Add dependency | `pyproject.toml` + `make install` | — |

## Key Files

| File | When to Read |
|---|---|
| `.context/STATE.md` | Every session (progress + test baseline) |
| `docs/session-protocol.md` | When unsure about session workflow |
| `docs/architecture.md` | Before structural changes |
