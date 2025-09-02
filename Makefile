# GSE POD Resolver - Makefile
# =============================

.PHONY: help install test lint format clean build docs deploy

# Variabili
PYTHON = python
PIP = pip
VENV = venv
PACKAGE_NAME = gse-pod-resolver
VERSION = 1.0.0

# Colori per output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Mostra questo messaggio di aiuto
	@echo "$(GREEN)GSE POD Resolver - Comandi disponibili:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

install: ## Installa le dipendenze
	@echo "$(GREEN)Installing dependencies...$(NC)"
	$(PIP) install -r requirements.txt

install-dev: ## Installa dipendenze di sviluppo
	@echo "$(GREEN)Installing development dependencies...$(NC)"
	$(PIP) install -r requirements.txt
	$(PIP) install pytest pytest-cov flake8 black mypy bandit safety

venv: ## Crea virtual environment
	@echo "$(GREEN)Creating virtual environment...$(NC)"
	$(PYTHON) -m venv $(VENV)
	@echo "$(GREEN)Virtual environment created. Activate with:$(NC)"
	@echo "$(YELLOW)  Windows: $(VENV)\\Scripts\\activate$(NC)"
	@echo "$(YELLOW)  Linux/Mac: source $(VENV)/bin/activate$(NC)"

test: ## Esegue i test
	@echo "$(GREEN)Running tests...$(NC)"
	$(PYTHON) -m pytest tests/ -v --cov=. --cov-report=html

test-quick: ## Esegue test rapidi
	@echo "$(GREEN)Running quick tests...$(NC)"
	$(PYTHON) gse_pod_resolver.py IT001E32728586

lint: ## Controlla la qualità del codice
	@echo "$(GREEN)Running linting...$(NC)"
	flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

format: ## Formatta il codice con black
	@echo "$(GREEN)Formatting code...$(NC)"
	black . --line-length=127

format-check: ## Controlla la formattazione del codice
	@echo "$(GREEN)Checking code formatting...$(NC)"
	black --check --diff . --line-length=127

security: ## Controlli di sicurezza
	@echo "$(GREEN)Running security checks...$(NC)"
	bandit -r . -f json -o bandit-report.json || true
	safety check --json --output safety-report.json || true

clean: ## Pulisce file temporanei
	@echo "$(GREEN)Cleaning temporary files...$(NC)"
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name "htmlcov" -exec rm -rf {} +
	find . -type f -name "*.log" -delete
	find . -type f -name "*.tmp" -delete
	find . -type f -name "*.temp" -delete

clean-venv: ## Rimuove virtual environment
	@echo "$(GREEN)Removing virtual environment...$(NC)"
	rm -rf $(VENV)

build: ## Costruisce il pacchetto
	@echo "$(GREEN)Building package...$(NC)"
	$(PYTHON) -m build

build-check: ## Controlla la build
	@echo "$(GREEN)Checking build...$(NC)"
	$(PYTHON) -m build --dry-run

install-local: ## Installa il pacchetto localmente
	@echo "$(GREEN)Installing package locally...$(NC)"
	$(PIP) install -e .

docs: ## Genera documentazione
	@echo "$(GREEN)Generating documentation...$(NC)"
	@echo "$(YELLOW)Documentation generation not yet implemented$(NC)"

deploy: ## Deploy su PyPI (richiede credenziali)
	@echo "$(GREEN)Deploying to PyPI...$(NC)"
	@echo "$(YELLOW)This requires PyPI credentials$(NC)"
	# twine upload dist/*

check-all: ## Esegue tutti i controlli
	@echo "$(GREEN)Running all checks...$(NC)"
	$(MAKE) format-check
	$(MAKE) lint
	$(MAKE) security
	$(MAKE) test

pre-commit: ## Prepara per commit
	@echo "$(GREEN)Preparing for commit...$(NC)"
	$(MAKE) format
	$(MAKE) lint
	$(MAKE) test-quick

demo: ## Esegue demo con POD di test
	@echo "$(GREEN)Running demo with test PODs...$(NC)"
	@echo "$(YELLOW)Testing POD: IT001E32728586$(NC)"
	$(PYTHON) gse_pod_resolver.py IT001E32728586
	@echo ""
	@echo "$(YELLOW)Testing POD: IT023E00091622$(NC)"
	$(PYTHON) gse_pod_resolver.py IT023E00091622
	@echo ""
	@echo "$(YELLOW)Testing POD: IT001E06772325$(NC)"
	$(PYTHON) gse_pod_resolver.py IT001E06772325

status: ## Mostra status del progetto
	@echo "$(GREEN)Project Status:$(NC)"
	@echo "$(YELLOW)Python version:$(NC) $(shell $(PYTHON) --version)"
	@echo "$(YELLOW)Pip version:$(NC) $(shell $(PIP) --version)"
	@echo "$(YELLOW)Virtual env:$(NC) $(shell if [ -d "$(VENV)" ]; then echo "Active"; else echo "Not found"; fi)"
	@echo "$(YELLOW)Dependencies:$(NC) $(shell if [ -f "requirements.txt" ]; then echo "Installed"; else echo "Not found"; fi)"

# Target per sviluppo
dev-setup: venv install-dev ## Setup completo per sviluppo
	@echo "$(GREEN)Development environment ready!$(NC)"
	@echo "$(YELLOW)Activate virtual environment and start coding!$(NC)"

# Target per produzione
prod-setup: venv install ## Setup per produzione
	@echo "$(GREEN)Production environment ready!$(NC)"

# Target per CI/CD
ci: format-check lint security test ## Target per CI/CD pipeline
	@echo "$(GREEN)CI/CD checks completed successfully!$(NC)"

# Target per release
release: clean build ## Prepara release
	@echo "$(GREEN)Release package built successfully!$(NC)"
	@echo "$(YELLOW)Check dist/ directory for artifacts$(NC)"

# Target per manutenzione
maintenance: clean clean-venv ## Manutenzione completa
	@echo "$(GREEN)Maintenance completed!$(NC)"
	@echo "$(YELLOW)Run 'make dev-setup' to recreate environment$(NC)"

# Target per debugging
debug: ## Mostra informazioni di debug
	@echo "$(GREEN)Debug Information:$(NC)"
	@echo "$(YELLOW)Current directory:$(NC) $(PWD)"
	@echo "$(YELLOW)Python executable:$(NC) $(shell which $(PYTHON))"
	@echo "$(YELLOW)Pip executable:$(NC) $(shell which $(PIP))"
	@echo "$(YELLOW)Make version:$(NC) $(shell make --version | head -1)"
	@echo "$(YELLOW)OS:$(NC) $(shell uname -s 2>/dev/null || echo "Windows")"
	@echo "$(YELLOW)Architecture:$(NC) $(shell uname -m 2>/dev/null || echo "Unknown")"

# Target per help esteso
help-extended: help ## Mostra aiuto esteso
	@echo ""
	@echo "$(GREEN)Extended Help:$(NC)"
	@echo "$(YELLOW)Development:$(NC)"
	@echo "  make dev-setup    - Setup completo per sviluppo"
	@echo "  make test         - Esegue tutti i test"
	@echo "  make lint         - Controlla qualità codice"
	@echo "  make format       - Formatta codice"
	@echo ""
	@echo "$(YELLOW)Production:$(NC)"
	@echo "  make prod-setup   - Setup per produzione"
	@echo "  make build        - Costruisce pacchetto"
	@echo "  make deploy       - Deploy su PyPI"
	@echo ""
	@echo "$(YELLOW)Maintenance:$(NC)"
	@echo "  make clean        - Pulisce file temporanei"
	@echo "  make maintenance  - Manutenzione completa"
	@echo "  make status       - Mostra status progetto"
