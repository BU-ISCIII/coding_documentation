# Coding documentation repository
This repository contains config files for vim, zsh, and template files for developing in BU-ISCIII

Here we will establish some programming rules and some development configuration for BU-ISCIII as well as code templates for most common programming languages in the unit: Python, bash and R

More information in the [wiki project](https://github.com/BU-ISCIII/dev_config_Files/wiki)

## Install
Dot files installation is very easy. First you have to clone the repository anywhere in your machine and init the submodules.

```
# Clone repository
git clone git@github.com:BU-ISCIII/coding_documentation.git
# Init and update submodules
git submodule init
git submodule update
```
Next you have to run install.sh file

```
# Run install.sh. You MUST provide your username in your local machine.
./install.sh -U <username>
```

## Update

For updating the repository and your dot files you have to update submodules and run install.sh with -r option.

```
# Update repository
git pull origin master
# Update submodules
git submodule update
# Run install.sh. You MUST provide your username in your local machine.
./install.sh -U <username> -r
```

## Uninstall
Run the install.sh script with -u option. This mode will delete all your vim and zsh configuration files from your home folder.

```
# Run install.sh. You MUST provide your username in your local machine.
./install.sh -U <username> -u
```
