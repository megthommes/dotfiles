#!/bin/bash
# Test that Homebrew is installed

RED='\033[0;31m'
RESET='\033[0m'

if ! command -v brew &> /dev/null; then
    echo -e "${RED}Error: Homebrew is not installed.${RESET}"
    exit 1
fi
