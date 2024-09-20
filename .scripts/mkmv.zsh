#!/bin/zsh

# Based on:
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/scripts.zsh
# by Matthieu Cneude

# mkmv: Create a directory if it doesn't exist and move files/directories into it.
#
# Usage: mkmv source destination
#
# Arguments:
#   source: File or directory to be moved.
#   destination: Target path. If it doesn't end with a slash, its parent directory will be created.
#
# Example:
#   mkmv file.txt /path/to/destination/
mkmv() {
    # Extract the destination path and check if it ends with a slash
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"

    # If the destination path does not end with '/', get its parent directory
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"

    # Create the  destination directory if it does not exist, then move the source
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        mv "$@"
}
