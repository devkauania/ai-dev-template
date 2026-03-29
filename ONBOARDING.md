# Project Onboarding — Agent Personalization Guide

> This file guides the AI agent through personalizing this template for your specific project.
> After onboarding is complete, this file can be deleted.

## Instructions for the AI Agent

When the user starts a new project from this template, follow these steps to personalize it.

### Step 1: Understand the Project

Ask the user these questions (use AskUserQuestion):

1. **What are you building?** (e.g., "REST API for e-commerce", "WhatsApp chatbot", "SaaS dashboard")
2. **What tech stack?** Choose from:
   - Python (FastAPI, Django, Flask)
   - Node.js (Express, Next.js, Remix)
   - Go
   - Other
3. **What's the business model?** (helps set architecture priorities)
4. **Do you already have external services?** (databases, APIs, auth providers, etc.)

### Step 2: Customize Files

Based on user answers, update these files:

#### CLAUDE.md
- Replace `{{PROJECT_NAME}}` with actual name
- Replace `{{ONE_LINE_DESCRIPTION}}` with project description
- Update "Where to Modify" table for actual project structure
- Add project-specific rules if needed

#### .context/STATE.md
- Replace `{{PROJECT_NAME}}` and `{{DATE}}`
- Plan initial sessions (S0-S3+) based on project scope
- Set up test baseline areas matching actual structure

#### pyproject.toml (Python) or package.json (Node.js)
- Set correct project name, version, dependencies
- Configure linter for the stack

#### Makefile
- Adapt commands for the chosen stack:
  - Python: `uv`, `pytest`, `ruff`
  - Node.js: `npm`, `vitest`/`jest`, `eslint`
  - Go: `go`, `go test`, `golangci-lint`

#### .claude/launch.json
- Set up preview server for the chosen stack
- Configure correct port and command

#### .claude/settings.json
- Add stack-specific tool permissions if needed
- Keep the deny list for branch/worktree protection

#### src/ directory
- Restructure for the chosen architecture:
  - Clean Architecture (default): api/services/domain/infra
  - MVC: controllers/models/views
  - Hexagonal: ports/adapters/domain
  - Monorepo: packages/shared, packages/api, etc.

#### .env.example
- Add project-specific environment variables
- Document each with comments above (not inline)

### Step 3: Run S0

After personalization, execute Session 0:
1. Install dependencies (`make install`)
2. Verify test framework works (create a trivial test)
3. Verify linter works (`make lint`)
4. Run `make validate` — should pass with 1+ test
5. Update STATE.md: mark S0 as Done, set test baseline
6. The project is now ready for feature development

### Step 4: Clean Up

- Delete this `ONBOARDING.md` file
- Commit the personalized template

---

## Stack-Specific Adaptations

### Python (FastAPI)
```
src/
├── api/routes/     # FastAPI routers
├── services/       # Business logic
├── domain/         # Entities, value objects
├── infra/          # Postgres, Redis, external APIs
└── settings.py     # Pydantic BaseSettings
```

### Node.js (Next.js)
```
src/
├── app/            # Next.js app router
├── components/     # React components
├── lib/            # Business logic, utilities
├── db/             # Database models, migrations
└── config/         # Environment config
```

### Node.js (Express)
```
src/
├── routes/         # Express routes
├── services/       # Business logic
├── models/         # Data models
├── middleware/      # Auth, validation, logging
└── config/         # Environment config
```

### Go
```
cmd/                # Entry points
internal/
├── handler/        # HTTP handlers
├── service/        # Business logic
├── domain/         # Entities
├── repository/     # Data access
└── config/         # Configuration
```

### Monorepo (any stack)
```
packages/
├── shared/         # Common types, utilities
├── api/            # HTTP layer
├── core/           # Business logic
├── persistence/    # Database layer
└── infra/          # External services
```
