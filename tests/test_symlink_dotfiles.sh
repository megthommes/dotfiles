#!/bin/bash
# Test that the dotfiles are symlinked
echo "Testing that the files are symlinked..."

FILES_TO_TEST=(
    "$ZDOTDIR/.zshrc"
    "$ZDOTDIR/.path.sh"
    "$ZDOTDIR/.env_vars.sh"
    "$ZDOTDIR/.shortcuts.sh"
    "$HOME/.gitconfig"
    "$HOME/.ssh/config"
    "$XDG_CONFIG_HOME/tmux/.tmux.conf"
)

for file in "${FILES_TO_TEST[@]}"; do
    test -f $file
    if [ $? != 0 ]; then
        echo "Error: $file does not exist";
    fi
done
echo "...done testing files"

echo "Testing that the directories are symlinked..."
DIRECTORIES_TO_TEST=(
    "$ZDOTDIR/.scripts"
    "$ZDOTDIR/.shell_aliases"
    "$ZDOTDIR/.plugins"
)
for directory in "${DIRECTORIES_TO_TEST[@]}"; do
    test -d $directory
    if [ $? != 0 ]; then
        echo "Error: $directory does not exist";
    fi
done
echo "...done testing directories"
