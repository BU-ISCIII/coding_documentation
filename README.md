# Dotfiles repository
This repository contains config files for vim, zsh, and tmux

## Install
Dot files installation is very easy. First you have to clone the repository anywhere in your machine and init the submodules.

```Bash
# Clone repository
git clone git@github.com:BU-ISCIII/dotfiles.git
# Init and update submodules
cd coding_documentation
git submodule init
git submodule update
```
Next you have to run install.sh file

```Bash
# Run install.sh. You MUST provide your username in your local machine.
./install.sh -U <username>
```

## Update

For updating the repository and your dot files you have to update submodules and run install.sh with -r option.

```Bash
# Update repository
git pull origin master
# Update submodules
git submodule update
# Run install.sh. You MUST provide your username in your local machine.
./install.sh -U <username> -r
```

## Uninstall
Run the install.sh script with -u option. This mode will delete all your vim and zsh configuration files from your home folder.

```Bash
# Run install.sh. You MUST provide your username in your local machine.
./install.sh -U <username> -u
```
