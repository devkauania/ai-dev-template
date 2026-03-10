# Architecture

## Overview

<!-- Describe your project's high-level architecture here -->
<!-- This file is referenced by AI agents before making structural changes -->

```
┌─────────────────────────────────────────┐
│              Your App                    │
├──────────┬──────────┬───────────────────┤
│   API    │ Services │   Domain          │
│ (routes) │ (logic)  │ (entities, repos) │
├──────────┴──────────┴───────────────────┤
│         Infrastructure                   │
│    (database, cache, external APIs)      │
└─────────────────────────────────────────┘
```

## Directory Structure

```
src/
├── api/              # HTTP routes, middleware, schemas
│   └── routes/
├── services/         # Business logic
├── domain/           # Entities, value objects, repository interfaces
│   ├── entities/
│   └── repos/
├── infra/            # Concrete implementations (DB, cache, APIs)
└── settings.py       # Configuration (env vars)

tests/
├── api/
├── services/
├── domain/
└── infra/
```

## Design Principles

1. **Domain layer has no dependencies** — pure Python, no frameworks
2. **Services orchestrate** — they call repos and apply business rules
3. **API layer is thin** — validates input, calls service, returns response
4. **Infrastructure is swappable** — repos are abstract, implementations are concrete

## Dependency Flow

```
API → Services → Domain ← Infrastructure
```

API depends on Services. Services depend on Domain (abstractions).
Infrastructure implements Domain interfaces. Nothing depends on Infrastructure directly.
