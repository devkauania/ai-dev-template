# {{PROJECT_NAME}} — AI Agent Navigation Guide

> Read this FIRST. Then read `.context/STATE.md` for current session.

## Project Identity

**{{PROJECT_NAME}}** — one-line description of your project.
<!-- Example: "A low-latency API gateway for RevOps" -->

## Critical Rules

1. **Zero regressions**: If a passing test now fails, fix it before session ends.
2. **One feature per session**: Don't mix unrelated features.
3. **No worktrees/branches**: All work happens directly on `master`.
4. **Same chat**: Continue in the current conversation. Only start a new chat if context becomes too large.
5. **Preview always on**: Keep a preview server running during development via `.claude/launch.json`.
6. **Test first**: Write the test → make it pass → refactor.
7. **Null fallback**: Every service gets a `NullXxxService`. Feature flags control activation.

<!-- Add your own project-specific rules here -->

## Quick Commands

```bash
make install          # Install all dependencies
make test             # Run ALL tests
make test-<pkg>       # One package (e.g., make test-api)
make lint             # Linter check
make validate         # Full: tests + lint
```

## End-of-Session Validation

Run `make validate`. If regressions found, fix before ending.
See `docs/session-protocol.md` for detailed checklist.

## Current Status

See `.context/STATE.md` for session progress, test counts, and what's next.

## Where to Modify

<!-- Map common tasks to file locations — this is the most important section -->
<!-- The AI agent uses this table to know WHERE to make changes -->

| I need to... | Files | Tests |
|---|---|---|
| Add an API route | `src/api/routes/` | `tests/api/` |
| Add a service | `src/services/` | `tests/services/` |
| Add a domain entity | `src/domain/entities/` | `tests/domain/` |
| Add a repository | `src/domain/repos/` (abstract) + `src/infra/` (impl) | `tests/infra/` |
| Add env var | `.env.example` + `src/settings.py` | — |
| Add dependency | `pyproject.toml` + install | — |

## Key Files

| File | When to Read |
|---|---|
| `.context/STATE.md` | Every session (progress + test baseline) |
| `docs/session-protocol.md` | When unsure about session workflow |
| `docs/architecture.md` | Before structural changes |
