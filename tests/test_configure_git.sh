#!/bin/bash
# Test that Git is configured
echo "Testing that Git is configured..."

# check if GitHub CLI is installed
echo "Checking if GitHub CLI is installed..."
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI is not installed."
    exit 1
fi
echo "...GitHub CLI is installed."

# check if the SSH key file exists
echo "Checking if the SSH key file exists..."
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
    echo "Error: SSH key file ~/.ssh/id_ed25519 does not exist."
    exit 1
fi
echo "...SSH key file exists."

# check if the SSH key is added to GitHub
echo "Checking if the SSH key is added to GitHub..."
PUBLIC_KEY=$(cat ~/.ssh/id_ed25519.pub | awk '{print $2}')
# authentication
if ! gh ssh-key list | grep -Fw "$PUBLIC_KEY" | grep -q "authentication"; then
    echo "Error: SSH key is not added to GitHub as an authentication key."
else
    ssh -T git@github.com
fi
echo "...done checking SSH key."

# check if the GPG key file exists
echo "Checking if the GPG key file exists..."
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}' | awk -F'/' '{print $2}')
if [ -z "$GPG_KEY_ID" ]; then
    echo "Error: No GPG key found."
    exit 1
fi
echo "...GPG key file exists."

# check if the GPG key is added to GitHub
echo "Checking if the GPG key is added to GitHub..."
if ! gh gpg-key list | grep -q "$GPG_KEY_ID"; then
    echo "Error: GPG key is not added to GitHub."
fi
echo "...done checking GPG key."

# check if the submodules are installed
echo "Checking if submodules are installed..."
SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
# Check each submodule
for submodule in $SUBMODULES; do
    if [ ! -d "$submodule" ] || [ -z "$(ls -A "$submodule")" ]; then
        echo "Error: Submodule $submodule is not installed or empty."
        exit 1
    fi
done
echo "...done checking submodules"

echo "...done testing Git"
