# Mac installation script

#!/bin/sh

echo "Starting installation..."
echo "----------------------------------------"

[ "${SHELL##/*/}" != "zsh" ] && echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'

# Step 1: Create directories
chmod +x ./install_scripts/create_directories.sh
./install_scripts/create_directories.sh
chmod -x ./install_scripts/create_directories.sh
echo "----------------------------------------"

# Step 2: Install Homebrew
chmod +x ./install_scripts/install_homebrew.sh
./install_scripts/install_homebrew.sh
chmod -x ./install_scripts/install_homebrew.sh
echo "----------------------------------------"

# Step 3: Install additional packages using Homebrew
chmod +x ./install_scripts/install_homebrew_packages.sh
./install_scripts/install_homebrew_packages.sh
chmod -x ./install_scripts/install_homebrew_packages.sh
echo "----------------------------------------"

# Step 4: Now install zshrc from this repo
chmod +x ./install_scripts/symlink_dotfiles.sh
./install_scripts/symlink_dotfiles.sh
chmod -x ./install_scripts/symlink_dotfiles.sh
echo "----------------------------------------"

# Step 5: Configure Git
chmod +x ./install_scripts/configure_git.sh
./install_scripts/configure_git.sh
chmod -x ./install_scripts/configure_git.sh
echo "----------------------------------------"