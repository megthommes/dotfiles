#!/bin/bash
# Configure Git
echo "Configuring Git..."

# use computer name for key name
KEY_NAME=$(scutil --get LocalHostName)
if [ -z "$KEY_NAME" ]; then
    echo "\033[0;31mError: Could not determine computer name.\033[0m"
    exit 1
fi

# get name and email from .gitconfig
GIT_NAME=$(git config --get user.name)
GIT_EMAIL=$(git config --get user.email)
if [ -z "$GIT_NAME" ]; then
    echo "\033[0;31mError: Git user name not set.\033[0m"
    exit 1
fi
if [ -z "$GIT_EMAIL" ]; then
    echo "\033[0;31mError: Git email not set.\033[0m"
    exit 1
fi

# check to see if existing SSH key
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
    echo "\033[0;33mSSH key does not exist. Generating...\033[0m"
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
fi
# check to see if existing GPG key
if ! gpg --list-secret-keys --keyid-format=long | grep -q "$GIT_EMAIL"; then
    echo "\033[0;33mGPG key does not exist. Generating...\033[0m"
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
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# add SSH and GPG keys to GitHub
if ! command -v gh &> /dev/null; then
    echo "\033[0;33mGitHub CLI not found. Installing...\033[0m"
    brew install gh || sudo apt-get install gh
fi
SSH_PUBLIC_KEY=$(cat ~/.ssh/id_ed25519.pub | awk '{print $2}')
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | awk -F'/' '{print $2}')
# authentication
if ! gh ssh-key list | grep -Fw "$SSH_PUBLIC_KEY" | grep -q "authentication"; then
    if gh ssh-key add ~/.ssh/id_ed25519.pub --title "$KEY_NAME" --type authentication; then
        echo "\033[0;32mSuccess: SSH key added to GitHub for authentication.\033[0m"
    else
        echo "\033[0;33mWarning: Failed to add SSH key to GitHub for authentication.\033[0m"
    fi
fi
# signing
if ! gh gpg-key list | grep -q "$GPG_KEY_ID"; then
    if gpg --armor --export $GPG_KEY_ID | gh gpg-key add - --title "$KEY_NAME"; then
        echo "\033[0;32mSuccess: GPG key added to GitHub for signing.\033[0m"
    else
        echo "\033[0;33mWarning: Failed to add GPG key to GitHub for signing.\033[0m"
    fi
fi
# Create or update .gitconfig.local
echo "Updating .gitconfig.local with GPG key..."
if [ ! -f "$HOME/.gitconfig.local" ]; then
    touch "$HOME/.gitconfig.local"
fi
git config --file "$HOME/.gitconfig.local" user.signingkey "$GPG_KEY_ID"

# install submodules
git submodule update --init --recursive

echo "...Git configured."
