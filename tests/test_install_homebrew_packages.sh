# Test that Homebrew packages are installed

echo "Testing that Homebrew packages are installed..."

source ./utils/homebrew_packages.zsh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "\tError: Homebrew is not installed."
    exit 1
fi

echo "\tTesting that regular brew packages are installed..."
for pkg in "${BREW_PACKAGES[@]}"; do
    if ! brew list --formula | grep -q "^${pkg}\$"; then
        echo "\t\tError: $pkg is not installed."
    fi
done
echo "\t...done testing regular brew packages"

echo "\tTesting that cask packages are installed..."
for pkg in "${CASK_PACKAGES[@]}"; do
    if ! brew list --cask | grep -q "^${pkg}\$"; then
        echo "\t\tError: $pkg is not installed."
    fi
done
echo "\t...done testing cask packages"

echo "...done testing Homebrew packages"