#!/bin/bash
# Install Homebrew

TEAL='\033[0;36m'
RESET='\033[0m'

if ! command -v brew &> /dev/null; then
    echo -e "${TEAL}Info: Homebrew is not installed; installing now...${RESET}"
    git clone https://github.com/Homebrew/brew homebrew
    eval "$(/homebrew/bin/brew shellenv)"
    brew update --force --quiet
    chmod -R go-w "$(brew --prefix)/share/zsh"
fi
