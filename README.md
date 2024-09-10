# Meghan's dotfiles

This repository contains my personal dotfiles and configuration files for my development environment.

## Inspiration

[Configuring Zsh Without Dependencies](https://thevaluable.dev/zsh-install-configure-mouseless) ([Matthieu Cneude's dotfiles](https://github.com/Phantas0s/.dotfiles))

[Data Science Bootstrap](https://ericmjl.github.io/data-science-bootstrap-notes) ([Eric Ma's dotfiles](https://github.com/ericmjl/dotfiles))

[Paul Miller's dotfiles](https://github.com/paulmillr/dotfiles)

[Zach Holman's dotfiles](https://github.com/holman/dotfiles)

## Installation

### For myself

```sh
$ cd ~
$ git clone git@github.com:megthommes/dotfiles
$ cd dotfiles
$ ./install.sh
```

### For others

Fork the repository and clone to your local machine.

```sh
$ cd ~
```

If you have SSH access enabled:

```sh
$ git clone git@github.com:YOUR-USERNAME/dotfiles
```

If you don't have SSH access enabled:

```sh
$ git clone https://github.com/YOUR-USERNAME/dotfiles
```

Modify `.gitconfig` to set your name, email, and username, then run the install script:

```sh
$ cd dotfiles
$ ./install.sh
```

and source the `.zshrc` file to apply the changes:

```sh
$ reshell # alias for `source ~/.zshrc`
```