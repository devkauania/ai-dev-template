# dev-template

A project template optimized for AI-assisted development with Claude Code, Cursor, and similar tools.

## What is this?

A ready-to-use project structure that makes AI coding agents **10x more productive**. Instead of the AI guessing where files go, what tests exist, or what the project does — everything is documented in a format agents understand natively.

> **Full documentation**: See [`docs/guide.md`](docs/guide.md) for a deep dive into how everything works and why each decision was made.

## What's included

```
.
├── CLAUDE.md                 # AI agent instructions (reads this first)
├── .context/
│   └── STATE.md              # Session tracking, test baselines, progress
├── .claude/
│   ├── launch.json           # Preview server config
│   └── settings.json         # Permission rules (no branches, no worktrees)
├── docs/
│   ├── session-protocol.md   # How sessions work
│   └── architecture.md       # System design reference
├── src/                      # Source code (clean architecture)
│   ├── api/routes/           # HTTP layer
│   ├── services/             # Business logic
│   ├── domain/entities/      # Domain models
│   ├── domain/repos/         # Repository interfaces
│   └── infra/                # Implementations (DB, cache, APIs)
├── tests/                    # Mirror of src/
├── Makefile                  # Dev shortcuts (test, lint, validate)
├── pyproject.toml            # Python config + dependencies
├── .env.example              # Environment variables template
└── .gitignore
```

## How to use

### 1. Clone and customize

```bash
git clone https://github.com/devkauania/ai-dev-template.git my-project
cd my-project
rm -rf .git && git init
```

### 2. Fill in the placeholders

Replace `{{PROJECT_NAME}}` in these files:
- `CLAUDE.md` — your project name and description
- `.context/STATE.md` — your session plan
- `.env.example` — your env vars
- `pyproject.toml` — package name

### 3. Update the "Where to Modify" table

This is the **most important part**. Open `CLAUDE.md` and update the table to match YOUR project structure. This table is what tells the AI agent exactly where to make changes.

### 4. Plan your sessions

Open `.context/STATE.md` and list your features as numbered sessions:

```markdown
| Session | Feature | Status | Depends On |
|---------|---------|--------|------------|
| S0 | Project setup | Done | — |
| S1 | User authentication | In Progress | — |
| S2 | Product catalog | Pending | S1 |
| S3 | Shopping cart | Pending | S2 |
```

### 5. Start developing

```bash
make install    # Install deps
make test       # Run tests
make validate   # Full validation
```

## Why this works

AI agents (Claude Code, Cursor, etc.) are powerful but they waste time when they don't know:
- **Where** files are → `CLAUDE.md` "Where to Modify" table solves this
- **What** to do next → `.context/STATE.md` session plan solves this
- **How** to validate → `make validate` + session protocol solves this
- **What** rules to follow → `CLAUDE.md` "Critical Rules" solves this

The result: tasks that take a solo dev 4 hours get done in ~15 minutes.

## Session workflow

```
1. AI reads CLAUDE.md     → knows the rules and file locations
2. AI reads STATE.md      → knows what session/feature to work on
3. AI writes tests first  → red
4. AI implements          → green
5. AI runs make validate  → confirms zero regressions
6. AI updates STATE.md    → tracks progress for next session
```

## Adapting for your stack

This template defaults to Python + uv, but the **structure** works for any stack:

| Stack | Adjust |
|-------|--------|
| **Node.js** | Change `Makefile` commands to `npm`/`pnpm`, `pyproject.toml` → `package.json` |
| **Go** | Change `src/` to standard Go layout, `Makefile` to `go test ./...` |
| **Rust** | Change to `cargo` commands, `src/` to `src/lib.rs` structure |
| **Monorepo** | Add `packages/` dir, run tests per-package (like Blink does) |

The key files (`CLAUDE.md`, `STATE.md`, `session-protocol.md`) work with **any language**.

## License

MIT — use it however you want.
