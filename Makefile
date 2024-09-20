SHELL := /bin/zsh

RED = \033[0;31m
TEAL = \033[0;36m
RESET = \033[0m

.PHONY: install
install: ## Install dotfiles
	@echo "$(TEAL)install$(RESET)"
	@echo
	@$(MAKE) check-zsh
	@echo
	@$(MAKE) create-directories
	@echo
	@$(MAKE) install-homebrew
	@echo
	@$(MAKE) install-homebrew-packages
	@echo
	@$(MAKE) symlink-dotfiles
	@echo
	@$(MAKE) configure-git
	@echo
	@$(MAKE) reshell
	@echo
	@$(MAKE) configure-macos
	@echo
	@$(MAKE) test-install

.PHONY: reshell
reshell:  ## Reshell
	@echo "$(TEAL)reshell$(RESET)"
	@if [ -f $$ZDOTDIR/.zshrc ]; then \
		source $$ZDOTDIR/.zshrc; \
	fi

.PHONY: check-zsh
check-zsh:  ## Check if zsh is the default shell
	@echo "$(TEAL)check-zsh$(RESET)"
	@if [ "$${SHELL##*/}" != "zsh" ]; then \
		echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'; \
	fi

.PHONY: create-directories
create-directories:  ## Create directories
	@echo "$(TEAL)create-directories$(RESET)"
	@chmod +x ./install_scripts/create_directories.sh
	@./install_scripts/create_directories.sh
	@chmod -x ./install_scripts/create_directories.sh

.PHONY: install-homebrew
install-homebrew:  ## Install Homebrew
	@echo "$(TEAL)install-homebrew$(RESET)"
	@chmod +x ./install_scripts/install_homebrew.sh
	@./install_scripts/install_homebrew.sh
	@chmod -x ./install_scripts/install_homebrew.sh

.PHONY: install-homebrew-packages
install-homebrew-packages:  ## Install additional packages using Homebrew
	@echo "$(TEAL)install-homebrew-packages$(RESET)"
	@chmod +x ./install_scripts/install_homebrew_packages.sh
	@./install_scripts/install_homebrew_packages.sh
	@chmod -x ./install_scripts/install_homebrew_packages.sh

.PHONY: symlink-dotfiles
symlink-dotfiles:  ## Symlink dotfiles
	@echo "$(TEAL)symlink-dotfiles$(RESET)"
	@chmod +x ./install_scripts/symlink_dotfiles.sh
	@./install_scripts/symlink_dotfiles.sh
	@chmod -x ./install_scripts/symlink_dotfiles.sh

.PHONY: configure-macos
configure-macos:  ## Configure MacOS
	@echo "$(TEAL)configure-macos$(RESET)"
	@chmod +x ./install_scripts/configure_macos.sh
	@./install_scripts/configure_macos.sh
	@chmod -x ./install_scripts/configure_macos.sh
	echo "$(RED)Note that some of these changes require a logout/restart to take effect.($RESET)"

.PHONY: configure-git
configure-git:  ## Configure Git
	@echo "$(TEAL)configure-git$(RESET)"
	@chmod +x ./install_scripts/configure_git.sh
	@./install_scripts/configure_git.sh
	@chmod -x ./install_scripts/configure_git.sh

.PHONY: test-install
test-install:  ## Run tests
	@echo "$(TEAL)test-install$(RESET)"
	@chmod +x tests/*
	@./tests/test_create_directories.sh
	@./tests/test_install_homebrew.sh
	@./tests/test_install_homebrew_packages.sh
	@./tests/test_symlink_dotfiles.sh
	@./tests/test_configure_git.sh
	@chmod -x tests/*

.PHONY: pre-commit-staged
pre-commit-staged:  ## Run pre-commit on staged files
	@echo "$(TEAL)pre-commit-staged$(RESET)"
	@pre-commit run --files $(git diff --cached --name-only)

.PHONY: pre-commit-all
pre-commit-all:  ## Run pre-commit on all files
	@echo "$(TEAL)pre-commit-all$(RESET)"
	@pre-commit run --all-files

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%s%s%s\n", $$1, FS, $$2}' | sort -t: -k1,1 -k2 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s$(RESET) %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
