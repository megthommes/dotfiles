#!/bin/bash
# Test that Git is configured

RED='\033[0;31m'
RESET='\033[0m'

# check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI is not installed.${RESET}"
    exit 1
fi

# check if the SSH key file exists
SSH_KEY_FILE="$HOME/.ssh/id_ed25519"
if [ ! -f "SSH_KEY_FILE" ]; then
    echo -e "${RED}Error: SSH key file $SSH_KEY_FILE does not exist.${RESET}"
    exit 1
fi

# check if the SSH key is added to GitHub
PUBLIC_KEY=$(awk '{print $2}' "$SSH_KEY_FILE.pub")
# authentication
if ! gh ssh-key list | grep -Fw "$PUBLIC_KEY" | grep -q "authentication"; then
    echo -e "${RED}Error: SSH key is not added to GitHub as an authentication key.${RESET}"
else
    ssh -T git@github.com
fi

# check if the GPG key file exists
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | awk -F'/' '{print $2}')
if [ -z "$GPG_KEY_ID" ]; then
    echo -e "${RED}Error: No GPG key found.${RESET}"
    exit 1
fi

# check if the GPG key is added to GitHub
if ! gh gpg-key list | grep -q "$GPG_KEY_ID"; then
    echo -e "${RED}Error: GPG key is not added to GitHub.${RESET}"
fi

# check if the submodules are installed
SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
# Check each submodule
for submodule in $SUBMODULES; do
    if [ ! -d "$submodule" ] || [ -z "$(ls -A "$submodule")" ]; then
        echo -e "${RED}Error: Submodule $submodule is not installed or empty.${RESET}s"
        exit 1
    fi
done
