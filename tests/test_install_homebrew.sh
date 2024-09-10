# Test that Homebrew is installed

echo "Testing that Homebrew is installed..."

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed."
    exit 1
fi

echo "...Homebrew is installed."