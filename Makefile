# {{PROJECT_NAME}} — Developer Shortcuts
# Usage: make <target>
# Run `make help` to see all available targets.

.PHONY: help install test lint format validate clean

# ============================================================
# Help
# ============================================================

help: ## Show this help message
	@echo "Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ============================================================
# Setup
# ============================================================

install: ## Install all dependencies
	uv sync

# ============================================================
# Testing
# ============================================================

test: ## Run all tests
	uv run pytest tests/ -v --tb=short

test-api: ## Run API tests
	uv run pytest tests/api/ -v

test-services: ## Run service tests
	uv run pytest tests/services/ -v

test-domain: ## Run domain tests
	uv run pytest tests/domain/ -v

test-infra: ## Run infrastructure tests
	uv run pytest tests/infra/ -v

test-cov: ## Run tests with coverage report
	uv run pytest tests/ --cov=src --cov-report=term-missing

# ============================================================
# Code Quality
# ============================================================

lint: ## Run ruff linter
	uv run ruff check .

lint-fix: ## Run ruff with auto-fix
	uv run ruff check . --fix

format: ## Format code with ruff
	uv run ruff format .

# ============================================================
# Full Validation (end-of-session)
# ============================================================

validate: test lint ## Full validation: tests + lint
	@echo ""
	@echo "============================================"
	@echo "  VALIDATION COMPLETE"
	@echo "============================================"
	@echo ""
	git status
	git log --oneline -5

# ============================================================
# Utilities
# ============================================================

clean: ## Remove caches and temp files
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .pytest_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .ruff_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@echo "Cleaned."

tree: ## Show project structure
	@find src/ tests/ -name "*.py" | sort | head -60
