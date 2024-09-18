SHELL := /bin/zsh

.PHONY: install update reshell check-zsh create-directories install-homebrew install-homebrew-packages symlink-dotfiles configure-git

install: ## Install dotfiles
	@echo "\033[0;36minstall\033[0m"
	@echo "Starting dotfiles installation..."
	@echo
	@$(MAKE) check-zsh
	@$(MAKE) create-directories
	@$(MAKE) install-homebrew
	@$(MAKE) install-homebrew-packages
	@$(MAKE) symlink-dotfiles
	@$(MAKE) configure-git
	@$(MAKE) reshell
	@$(MAKE) configure-macos
	@$(MAKE) test
	@echo
	@echo "Dotfiles installation complete!"

update:  ## Update dotfiles
	@echo "\033[0;36mupdate\033[0m"
	@echo "Updating dotfiles..."
	@echo
	@$(MAKE) create-directories
	@$(MAKE) install-homebrew-packages
	@$(MAKE) symlink-dotfiles
	@$(MAKE) reshell
	@$(MAKE) test
	@echo
	@echo "Dotfiles updated!"

reshell:  ## Reshell
	@echo "\033[0;36mreshell\033[0m"
	@echo "Sourcing .zshrc..."
	@if [ -f $$ZDOTDIR/.zshrc ]; then \
		source $$ZDOTDIR/.zshrc; \
		echo "$$ZDOTDIR/.zshrc has been sourced."; \
	else \
		echo "$$ZDOTDIR/.zshrc not found. Skipping."; \
	fi
	@echo

check-zsh:  ## Check if zsh is the default shell
	@echo "\033[0;36mcheck-zsh\033[0m"
	@echo "Checking if zsh is the default shell..."
	@if [ "$${SHELL##*/}" != "zsh" ]; then \
		echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'; \
	else \
		echo "zsh is the default shell."; \
	fi
	@echo

create-directories:  ## Create directories
	@echo "\033[0;36mcreate-directories\033[0m"
	@chmod +x ./install_scripts/create_directories.sh
	@./install_scripts/create_directories.sh
	@chmod -x ./install_scripts/create_directories.sh
	@echo

install-homebrew:  ## Install Homebrew
	@echo "\033[0;36minstall-homebrew\033[0m"
	@chmod +x ./install_scripts/install_homebrew.sh
	@./install_scripts/install_homebrew.sh
	@chmod -x ./install_scripts/install_homebrew.sh
	@echo

install-homebrew-packages:  ## Install additional packages using Homebrew
	@echo "\033[0;36minstall-homebrew-packages\033[0m"
	@chmod +x ./install_scripts/install_homebrew_packages.sh
	@./install_scripts/install_homebrew_packages.sh
	@chmod -x ./install_scripts/install_homebrew_packages.sh
	@echo

symlink-dotfiles:  ## Symlink dotfiles
	@echo "\033[0;36msymlink-dotfiles\033[0m"
	@chmod +x ./install_scripts/symlink_dotfiles.sh
	@./install_scripts/symlink_dotfiles.sh
	@chmod -x ./install_scripts/symlink_dotfiles.sh
	@echo

configure-macos:  ## Configure MacOS
	@echo "\033[0;36mconfigure-macos\033[0m"
	@chmod +x ./install_scripts/configure_macos.sh
	@./install_scripts/configure_macos.sh
	@chmod -x ./install_scripts/configure_macos.sh
	@echo

configure-git:  ## Configure Git
	@echo "\033[0;36mconfigure-git\033[0m"
	@chmod +x ./install_scripts/configure_git.sh
	@./install_scripts/configure_git.sh
	@chmod -x ./install_scripts/configure_git.sh
	@echo

test:  ## Run tests
	@echo "\033[0;36mtest\033[0m"
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