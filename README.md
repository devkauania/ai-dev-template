# dev-template

A project template optimized for AI-assisted development with Claude Code, Cursor, and similar tools.

## What is this?

A ready-to-use project structure that makes AI coding agents dramatically more productive. Instead of the AI guessing where files go, what tests exist, or what the project does — everything is documented in a format agents understand natively.

> **Full documentation**: See [`docs/guide.md`](docs/guide.md) for a deep dive into how everything works.

## What's included

```
.
├── CLAUDE.md                 # AI agent instructions (reads this first)
├── ONBOARDING.md             # Agent personalization guide (delete after setup)
├── .context/
│   └── STATE.md              # Session tracking, test baselines, progress
├── .claude/
│   ├── launch.json           # Preview server config
│   ├── settings.json         # Permission rules (no branches, no worktrees)
│   ├── hookify.validate-before-stop.local.md
│   ├── hookify.credential-protection.local.md
│   ├── hookify.dangerous-commands.local.md
│   ├── hookify.env-safety.local.md
│   └── hookify.branch-protection.local.md
├── docs/
│   ├── session-protocol.md   # How sessions work + hook reference
│   ├── architecture.md       # System design reference
│   └── guide.md              # Deep dive (Portuguese)
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

## Quick Start

### Option A: Let the AI personalize it (recommended)

```bash
git clone https://github.com/devkauania/dev-template.git my-project
cd my-project
rm -rf .git && git init
```

Then open Claude Code and say: **"Read ONBOARDING.md and help me set up this project."**

The agent will ask what you're building, customize all files, and run S0 (setup session).

### Option B: Manual setup

1. Replace `{{PROJECT_NAME}}` in `CLAUDE.md`, `STATE.md`, `.env.example`, `pyproject.toml`
2. Update the "Where to Modify" table in `CLAUDE.md` for your structure
3. Plan sessions in `.context/STATE.md`
4. Delete `ONBOARDING.md`
5. `make install && make validate`

## Protection Hooks

5 hookify rules are included out of the box:

| Hook | What it does | Action |
|------|-------------|--------|
| **validate-before-stop** | Reminds the agent to run `make validate` before ending | warn |
| **credential-protection** | Detects hardcoded secrets in non-.env files | warn |
| **dangerous-commands** | Blocks `rm -rf /`, force push, `DROP TABLE` | **block** |
| **env-safety** | Reminds .env rules (no inline comments) when editing | warn |
| **branch-protection** | Explains master-only policy when agent tries to branch | warn |

**Prerequisite**: Install the [hookify plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/hookify) in Claude Code.

## Why this works

AI agents waste time when they don't know:
- **Where** files are → `CLAUDE.md` "Where to Modify" table
- **What** to do next → `.context/STATE.md` session plan
- **How** to validate → `make validate` + session protocol
- **What** rules to follow → `CLAUDE.md` "Critical Rules"
- **What** to avoid → hookify rules catch mistakes automatically

## Session Workflow

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

| Stack | What to change |
|-------|---------------|
| **Node.js** | `Makefile` commands → npm/pnpm, `pyproject.toml` → `package.json` |
| **Go** | `src/` → standard Go layout, `Makefile` → `go test ./...` |
| **Rust** | Cargo commands, `src/` → `src/lib.rs` structure |
| **Monorepo** | Add `packages/` dir, run tests per-package |

The key files (`CLAUDE.md`, `STATE.md`, hookify rules) work with **any language**.

## License

MIT
