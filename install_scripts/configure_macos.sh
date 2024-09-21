#!/bin/bash
# Configure MacOS

RED='\033[0;31m'
RESET='\033[0m'

if [ ! -f "$HOME/.macos" ]; then
    echo -e "${RED}Error: No .macos file found in home directory.${RESET}"
    exit 1
fi

chmod +x "$HOME/.macos"
"$HOME/.macos"
chmod -x "$HOME/.macos"
