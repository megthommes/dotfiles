# Configure Git
echo "Configuring Git..."

# check to see if existing SSH key
if [ ! -f $HOME/.ssh/id_ed25519 ]; then
    echo "SSH key does not exist. Generating..."
    ssh-keygen -t ed255519 -C "megan.thommes@gmail.com"
fi

# add SSH key to the ssh-agent
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# add SSH key to GitHub
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Installing..."
    brew install gh || sudo apt-get install gh
fi
PUBLIC_KEY=$(cat ~/.ssh/id_ed25519.pub | awk '{print $2}')
# signing
if ! gh ssh-key list | grep -Fw "$PUBLIC_KEY" | grep -q "signing"; then
    gh ssh-key add ~/.ssh/id_ed25519.pub --type signing
    echo "SSH key added to GitHub for signing."
fi
# authentication
if ! gh ssh-key list | grep -Fw "$PUBLIC_KEY" | grep -q "authentication"; then
    gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication
    echo "SSH key added to GitHub for authentication."
fi

# install submodules
git submodule update --init --recursive

echo "...Git configured."