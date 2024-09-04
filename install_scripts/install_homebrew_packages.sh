# Install homebrew packages that are not already be installed.
echo "Installing homebrew packages that are not already installed...."

source ./utils/homebrew_packages.zsh

# Check if brew is installed. If not, set path to include brew.
if ! command -v brew &> /dev/null; then    export OLDPATH=$PATH
    export ORIGINALLY_NO_BREW="true"
    echo "Setting path to include Homebrew temporarily."
    export PATH=$HOMEBREW_PREFIX/bin:$PATH
fi

# Install homebrew packages that might not already be installed.
for pkg in "${BREW_PACKAGES[@]}"; do
    if ! brew list --formula | grep -q "^${pkg}\$"; then
        echo "Installing $pkg"
    brew install "$pkg"
    fi
done
for pkg in "${CASK_PACKAGES[@]}"; do
    if ! brew list --cask | grep -q "^${pkg}\$"; then
        echo "Installing $pkg"
    brew install --cask "$pkg"
    fi
done

# Set path back to original brew.
if [ "$ORIGINALLY_NO_BREW" = "true" ]; then
    export PATH="$OLDPATH"
fi

echo "...Homebrew packages installed."