# ls / tree
if command -v lsd &> /dev/null; then
    alias ls='lsd'
    alias tree='lsd --tree --depth=2 --long -a --header --git'
fi

# ls
alias l='ls -lF'              # long format
alias la='ls -AF'             # all files, excluding current and parent directories
alias ll='ls -lAF'            # all files in long format, excluding current and parent directories
alias lls='ls -lAFhtr'        # `ll` sorted by modification time, oldest first
alias llg='ls -lAFhtr --git'  # `ll` sorted by modification time, oldest first, with git status

# grep
alias grep="grep -i --color=auto" # case-insensitive, colorized output

# cat
alias cat="bat"

# diff
alias diff="diff-so-fancy"

# find
alias find="fd"