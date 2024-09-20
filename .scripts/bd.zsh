#!/bin/zsh

# Based on:
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/plugins/bd.zsh
# by Matthieu Cneude

# bd: Navigate up the directory tree ("back directory").
#
# Usage:
#   bd <name-of-any-parent-directory>  - Navigate to the parent directory with the given name.
#   bd <number-of-folders>             - Navigate up the specified number of directory levels.
#
# Example:
#   If you are in /home/user/projects/myproject and run `bd projects`, it will change to /home/user/projects.
#   If you run `bd 2`, it will change to /home/user.
#
# Error Handling:
#   If no argument is provided, or if the directory name or number is invalid, an error message is shown.
#   If attempting to go up more levels than available, an error is displayed.
bd () {
  (($#<1)) && {
    print -- "usage: $0 <name-of-any-parent-directory>"
    print -- "       $0 <number-of-folders>"
    return 1
  } >&2

  local num_folders_we_are_in=${#${(ps:/:)${PWD}}}
  local dest="./"

  # Build a list of parent directories
  local parents
  local i
  for i in {$num_folders_we_are_in..2}
  do
    parents=($parents "$(echo $PWD | cut -d'/' -f$i)")
  done
  parents=($parents "/")

  # Try to find and navigate to the specified parent directory by name
  local parent
  foreach parent (${parents})
  do
    dest+="../"
    if [[ $1 == $parent ]]
    then
      cd $dest
      return 0
    fi
  done

  # If the user provided a number, go up the specified number of levels
  dest="./"
  if [[ "$1" = <-> ]]
  then
    if [[ $1 -gt $num_folders_we_are_in ]]
    then
      print -- "bd: Error: Can not go up $1 times (not enough parent directories)"
      return 1
    fi
    for i in {1..$1}
    do
      dest+="../"
    done
    cd $dest
    return 0
  fi

  # If no matching directory or invalid input, print an error message
  print -- "bd: Error: No parent directory named '$1'"
  return 1
}

_bd () {
  # Generate a list of parent directories for tab completion
  local num_folders_we_are_in=${#${(ps:/:)${PWD}}}
  local i
  for i in {$num_folders_we_are_in..2}
  do
    reply=($reply "`echo $PWD | cut -d'/' -f$i`")
  done
  reply=($reply "/")
}

compctl -V directories -K _bd bd
