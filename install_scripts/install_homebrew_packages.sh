#!/bin/bash
# Install homebrew packages that are not already be installed.

TEAL='\033[0;36m'
RESET='\033[0m'

source ./utils/homebrew_packages.sh

# Check if brew is installed. If not, set path to include brew.
if ! command -v brew &> /dev/null; then
    export OLDPATH=$PATH
    export ORIGINALLY_NO_BREW="true"
    echo -e "${TEAL}Info: Setting path to include Homebrew temporarily.${RESET}"
    export PATH=$HOMEBREW_PREFIX/bin:$PATH
fi

# Install homebrew packages that might not already be installed.
for pkg in "${BREW_PACKAGES[@]}"; do
    if ! brew list --formula | grep -q "^${pkg}\$"; then
        echo -e "${TEAL}Info: Installing $pkg.${RESET}"
        brew install "$pkg"
    fi
done
for pkg in "${CASK_PACKAGES[@]}"; do
    if ! brew list --cask | grep -q "^${pkg}\$"; then
        echo -e "${TEAL}Info: Installing $pkg.${RESET}"
        brew install --cask "$pkg"
    fi
done

# Set path back to original brew.
if [ "$ORIGINALLY_NO_BREW" = "true" ]; then
    export PATH="$OLDPATH"
fi
