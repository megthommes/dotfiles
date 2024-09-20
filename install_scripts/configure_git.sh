#!/bin/bash
# Configure Git

RED='\033[0;31m'
YELLOW='\033[0;33m'
TEAL='\033[0;36m'
BLUE='\033[0;34m'
RESET='\033[0m'

# use computer name for key name
KEY_NAME=$(scutil --get LocalHostName)
if [ -z "$KEY_NAME" ]; then
    echo -e "${RED}Error: Could not determine computer name.${RESET}"
    exit 1
fi

# get name and email from .gitconfig
GIT_NAME=$(git config --get user.name)
GIT_EMAIL=$(git config --get user.email)
if [ -z "$GIT_NAME" ]; then
    echo -e "${RED}Error: Git user name not set.${RESET}"
    exit 1
fi
if [ -z "$GIT_EMAIL" ]; then
    echo -e "${RED}Error: Git email not set.${RESET}"
    exit 1
fi

# check to see if existing SSH key
SSH_KEY_FILE="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_FILE" ]; then
    echo -e "${TEAL}Info: SSH key does not exist. Generating...${RESET}"
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_FILE" -N ""
fi
# check to see if existing GPG key
if ! gpg --list-secret-keys --keyid-format=long | grep -q "$GIT_EMAIL"; then
    echo -e "${TEAL}Info: GPG key does not exist. Generating...${RESET}"
    gpg --batch --status-fd 1 --with-colons --generate-key <<-EOF
        Key-Type: EDDSA
        Key-Curve: ed25519
        Subkey-Type: EDDSA
        Subkey-Curve: ed25519
        Name-Real: $GIT_NAME
        Name-Email: $GIT_EMAIL
        Expire-Date: 0
        %no-protection
        %commit
EOF
fi

# add SSH key to the ssh-agent
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add --apple-use-keychain "$SSH_KEY_FILE"

# add SSH and GPG keys to GitHub
if ! command -v gh &> /dev/null; then
    echo -e "${TEAL}Info: GitHub CLI not found. Installing..."
    brew install gh || sudo apt-get install gh
fi
SSH_PUBLIC_KEY=$(cat "$SSH_KEY_FILE.pub" | awk '{print $2}')
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | awk -F'/' '{print $2}')
# authentication
if ! gh ssh-key list | grep -Fw "$SSH_PUBLIC_KEY" | grep -q "authentication"; then
    if gh ssh-key add "$SSH_KEY_FILE.pub" --title "$KEY_NAME" --type authentication; then
        echo -e "${BLUE}Success: SSH key added to GitHub for authentication.${RESET}"
    else
        echo -e "${YELLOW}Warning: Failed to add SSH key to GitHub for authentication.${RESET}"
    fi
fi
# signing
if ! gh gpg-key list | grep -q "$GPG_KEY_ID"; then
    if gpg --armor --export $GPG_KEY_ID | gh gpg-key add - --title "$KEY_NAME"; then
        echo -e "${BLUE}Success: GPG key added to GitHub for signing.${RESET}"
    else
        echo -e "${YELLOW}Warning: Failed to add GPG key to GitHub for signing.${RESET}"
    fi
fi
# Create or update .gitconfig.local
echo -e "${TEAL}Info: Updating .gitconfig.local with GPG key...${RESET}"
if [ ! -f "$HOME/.gitconfig.local" ]; then
    touch "$HOME/.gitconfig.local"
fi
git config --file "$HOME/.gitconfig.local" user.signingkey "$GPG_KEY_ID"

# install submodules
git submodule update --init --recursive
