#!/bin/zsh

# Based on:
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/scripts.zsh
# by Matthieu Cneude

# mkcd: Create a directory and change into it.
#
# Usage:
#   mkcd <directory_name>
#
# Arguments:
#   <directory_name>: The name of the directory to create and enter.
#                     Can include multiple levels (e.g., "parent/child").
#
# Description:
#   This function creates a new directory (including any necessary parent
#   directories) and then changes the current working directory to the
#   newly created directory.
#
# Example:
#   mkcd my_new_project
#   mkcd path/to/new/directory
mkcd() {
    # Store all arguments as the directory name
    local dir="$*";

    # Create the directory (including parent directories if needed) and change to it
    # The -p flag allows mkdir to create parent directories as needed
    # The && ensures that cd is only executed if mkdir is successful
    mkdir -p "$dir" && cd "$dir";
}
