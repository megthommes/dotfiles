# Based on:
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/plugins/bd.zsh
# by Matthieu Cneude

# mkcp: Create a directory if it doesn't exist and copy files/directories into it.
#
# Usage:
#   mkcp source destination [options]
#
# Arguments:
#   $1: Source file or directory to copy.
#   $2: Destination path. If it doesn't end with a slash, the last component will be treated as the filename.
#   $@: Additional arguments are passed directly to the cp command.
#
# Examples:
#   mkcp file.txt /path/to/destination/     # Copies file.txt to /path/to/destination/file.txt
#   mkcp file.txt /path/to/destination/new_name.txt  # Copies file.txt to /path/to/destination/new_name.txt
#   mkcp -r source_dir /path/to/destination/  # Copies source_dir to /path/to/destination/source_dir
mkcp() {
    # Extract the destination path and check if it ends with a slash
    local dir="$2"
    local tmp="$2"; tmp="${tmp: -1}"

    # If the destination path does not end with '/', get its parent directory
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"

    # Create the destination directory if it does not exist, then perform the copy
    [ -d "$dir" ] ||
        mkdir -p "$dir" &&
        cp -r "$@"
}
