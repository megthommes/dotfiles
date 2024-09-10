SHELL := /bin/zsh

.PHONY: install reshell check-zsh create-directories install-homebrew install-homebrew-packages symlink-dotfiles configure-git

install: ## Install dotfiles
	@echo "Starting dotfiles installation..."
	@echo
	@$(MAKE) check-zsh
	@$(MAKE) create-directories
	@$(MAKE) install-homebrew
	@$(MAKE) install-homebrew-packages
	@$(MAKE) symlink-dotfiles
	@$(MAKE) configure-git
	@$(MAKE) reshell
	@$(MAKE) test
	@echo
	@echo "Dotfiles installation complete!"

reshell:  ## Reshell
	@echo "Sourcing .zshrc..."
	@if [ -f $$ZDOTDIR/.zshrc ]; then \
		source $$ZDOTDIR/.zshrc; \
		echo "$$ZDOTDIR/.zshrc has been sourced."; \
	else \
		echo "$$ZDOTDIR/.zshrc not found. Skipping."; \
	fi
	@echo

check-zsh:  ## Check if zsh is the default shell
	@echo "Checking if zsh is the default shell..."
	@if [ "$${SHELL##*/}" != "zsh" ]; then \
		echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'; \
	else \
		echo "zsh is the default shell."; \
	fi
	@echo

create-directories:  ## Create directories
	@echo "Creating directories..."
	@chmod +x ./install_scripts/create_directories.sh
	@./install_scripts/create_directories.sh
	@chmod -x ./install_scripts/create_directories.sh
	@echo

install-homebrew:  ## Install Homebrew
	@echo "Installing Homebrew..."
	@chmod +x ./install_scripts/install_homebrew.sh
	@./install_scripts/install_homebrew.sh
	@chmod -x ./install_scripts/install_homebrew.sh
	@echo

install-homebrew-packages:  ## Install additional packages using Homebrew
	@echo "Installing additional packages using Homebrew..."
	@chmod +x ./install_scripts/install_homebrew_packages.sh
	@./install_scripts/install_homebrew_packages.sh
	@chmod -x ./install_scripts/install_homebrew_packages.sh
	@echo

symlink-dotfiles:  ## Symlink dotfiles
	@echo "Symlinking dotfiles..."
	@chmod +x ./install_scripts/symlink_dotfiles.sh
	@./install_scripts/symlink_dotfiles.sh
	@chmod -x ./install_scripts/symlink_dotfiles.sh
	@echo

configure-git:  ## Configure Git
	@echo "Configuring Git..."
	@chmod +x ./install_scripts/configure_git.sh
	@./install_scripts/configure_git.sh
	@chmod -x ./install_scripts/configure_git.sh
	@echo

test:  ## Run tests
	@echo "Running tests..."
	@chmod +x tests/*
	@echo
	@./tests/test_create_directories.sh
	@echo
	@./tests/test_install_homebrew.sh
	@echo
	@./tests/test_install_homebrew_packages.sh
	@echo
	@./tests/test_symlink_dotfiles.sh
	@echo
	@./tests/test_configure_git.sh
	@echo
	@chmod -x tests/*
	@echo "Tests complete!"

# Help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%s%s%s\n", $$1, FS, $$2}' | sort -t: -k1,1 -k2 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help