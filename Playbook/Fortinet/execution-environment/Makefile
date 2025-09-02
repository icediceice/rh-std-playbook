# Makefile for Fortinet Execution Environment
# Simplifies common EE operations

.PHONY: help build push test clean validate all

# Default registry - override with: make build REGISTRY=your-registry.com
REGISTRY ?= quay.io/your-org
EE_NAME ?= fortinet-ee
EE_TAG ?= latest
CONTAINER_RUNTIME := $(shell command -v podman 2> /dev/null || echo docker)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

validate: ## Validate EE requirements
	@echo "Validating execution environment requirements..."
	@./validate-ee-requirements.sh

build: validate ## Build the execution environment
	@echo "Building execution environment..."
	ansible-builder build \
		--tag $(EE_NAME):$(EE_TAG) \
		--tag $(EE_NAME):$(shell date +%Y%m%d-%H%M%S) \
		--container-runtime $(CONTAINER_RUNTIME) \
		--verbosity 2

push: ## Push to registry (use REGISTRY=your-registry.com)
	@echo "Pushing to registry $(REGISTRY)..."
	$(CONTAINER_RUNTIME) tag $(EE_NAME):$(EE_TAG) $(REGISTRY)/$(EE_NAME):$(EE_TAG)
	$(CONTAINER_RUNTIME) push $(REGISTRY)/$(EE_NAME):$(EE_TAG)

test: ## Test the built image
	@echo "Testing execution environment..."
	@echo "=== Installed Collections ==="
	@$(CONTAINER_RUNTIME) run --rm $(EE_NAME):$(EE_TAG) ansible-galaxy collection list | grep -E "(fortinet|ansible.netcommon)"
	@echo ""
	@echo "=== Python Packages ==="
	@$(CONTAINER_RUNTIME) run --rm $(EE_NAME):$(EE_TAG) pip list | grep -E "(fortiosapi|paramiko|netaddr)"
	@echo ""
	@echo "=== Ansible Version ==="
	@$(CONTAINER_RUNTIME) run --rm $(EE_NAME):$(EE_TAG) ansible --version | head -1

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf context/ _build/
	@rm -f *.log *.tar *.tar.gz

all: clean build test ## Clean, build, and test

# Advanced targets
shell: ## Open shell in the EE container
	$(CONTAINER_RUNTIME) run --rm -it $(EE_NAME):$(EE_TAG) /bin/bash

inspect: ## Inspect the built image
	$(CONTAINER_RUNTIME) inspect $(EE_NAME):$(EE_TAG)

list-collections: ## List all installed collections
	$(CONTAINER_RUNTIME) run --rm $(EE_NAME):$(EE_TAG) ansible-galaxy collection list

list-python: ## List all Python packages
	$(CONTAINER_RUNTIME) run --rm $(EE_NAME):$(EE_TAG) pip list