#!/bin/bash
# Test that the dotfiles are symlinked

RED='\033[0;31m'
RESET='\033[0m'

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
        echo -e "${RED}Error: $file does not exist.${RESET}"
    fi
done

DIRECTORIES_TO_TEST=(
    "$ZDOTDIR/.scripts"
    "$ZDOTDIR/.shell_aliases"
    "$ZDOTDIR/.plugins"
)
for directory in "${DIRECTORIES_TO_TEST[@]}"; do
    test -d $directory
    if [ $? != 0 ]; then
        echo -e "${RED}Error: $directory does not exist.${RESET}"
    fi
done
