# Configure MacOS
echo "Configuring MacOS..."

if [ ! -f $HOME/.macos ]; then
    echo "\033[0;31mError: No .macos file found in home directory.\033[0m"
    exit 1
fi

chmod +x $HOME/.macos
$HOME/.macos
chmod -x $HOME/.macos
