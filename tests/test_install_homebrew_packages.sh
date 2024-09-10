# Test that Homebrew packages are installed

echo "Testing that Homebrew packages are installed..."

source ./utils/homebrew_packages.zsh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed."
    exit 1
fi

echo "Testing that regular brew packages are installed..."
for pkg in "${BREW_PACKAGES[@]}"; do
    if ! brew list --formula | grep -q "^${pkg}\$"; then
        echo "Error: $pkg is not installed."
    fi
done
echo "...done testing regular brew packages"

echo "Testing that cask packages are installed..."
for pkg in "${CASK_PACKAGES[@]}"; do
    if ! brew list --cask | grep -q "^${pkg}\$"; then
        echo "Error: $pkg is not installed."
    fi
done
echo "...done testing cask packages"

echo "...done testing Homebrew packages"