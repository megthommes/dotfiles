#!/bin/bash
# Test that Homebrew packages are installed

RED='\033[0;31m'
RESET='\033[0m'

# get homebrew packages to install
source ./utils/homebrew_packages.sh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Error: Homebrew is not installed.${RESET}"
    exit 1
fi

for pkg in "${BREW_PACKAGES[@]}"; do
    if ! brew list --formula | grep -q "^${pkg}\$"; then
        echo -e "${RED}Error: $pkg is not installed.${RESET}"
    fi
done

for pkg in "${CASK_PACKAGES[@]}"; do
    if ! brew list --cask | grep -q "^${pkg}\$"; then
        echo -e "${RED}Error: $pkg is not installed.${RESET}"
    fi
done
