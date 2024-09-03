# Install Homebrew
echo "Checking to see if Homebrew is installed..."

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed; installing now..."
    git clone https://github.com/Homebrew/brew homebrew
    eval "$(homebrew/bin/brew shellenv)"
    brew update --force --quiet
    chmod -R go-w "$(brew --prefix)/share/zsh"
fi

echo "...Homebrew installed."