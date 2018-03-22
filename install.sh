#!/bin/bash

# Exit immediately if a pipeline, which may consist of a single simple command, a list,
#or a compound command returns a non-zero status: If errors are not handled by user
#set -e

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error when performing parameter expansion.
# An error message will be written to the standard error, and a non-interactive shell will exit
#set -u

#Print everything as if it were executed, after substitution and expansion is applied: Debug|log option
#set -x

#=============================================================
# HEADER
#=============================================================

#INSTITUTION:ISCIII
#CENTRE:BU-ISCIII
#AUTHOR:
VERSION=1.0 #Version is set in order to be called with -v parameter
#CREATED: 21 March 2018
#REVISION:
#DESCRIPTION:Script for installing custom dot files.
#Features installed:
#   * Dependency check.
#   * Vim configuration, .vimrc and .vim
#   * Oh-my-zsh configuration: .zshrc and .oh-my-zsh with custom theme

#================================================================
# END_OF_HEADER
#================================================================

#SHORT USAGE RULES
        #Text without brackets or braces - Items you must type as shown
        #<Text inside angle brackets> - Placeholder for which you must supply a value
        #[Text inside square brackets] - Optional items
        ##{Text inside braces} - Set of required items; choose one
        #Vertical bar (|) - Separator for mutually exclusive items; choose one
        #Ellipsis (…) - Items that can be repeated
#LONG USAGE FUNCTION

usage() {
        cat << EOF
Dot files installation: Zsh and vim config

usage : $0 [-v] [-h] [-u]
                              -r update repositories and local files
        -u uninstall files
        -U username for home path
        -* options
        -v version
        -h display usage message
EOF

}

#================================================================
# OPTION_PROCESSING
#================================================================
#Make sure the script is executed with arguments
if [ $? != 0 ] ; then
 usage >&2
 exit 1
fi


#DECLARE FLAGS AND VARIABLES
rflag=0	            # boolean for mandatory options

update=false        # boolean update installation
uninstall=false     # boolean uninstall files

user=""             # username for home path install


#PARSE VARIABLE ARGUMENTS WITH getops
#common example with letters, for long options check longopts2getopts.sh
while getopts ":U:vhru" opt; do
        case $opt in
                h )
                   usage
                   exit 1
                  ;;
                v )
                   echo $VERSION
                   exit 1
                  ;;
                r )
                   update=true
                  ;;
                u )
                   uninstall=true
                  ;;
                U)
                   rflag=$(($rflag+1));user=$OPTARG
                  ;;
                \?)
                   echo "Invalid Option: -$OPTARG" 1>&2
                   usage
                   exit 1
                  ;;
                : )
                   echo "Option -$OPTARG requires an argument." >&2
                   exit 1
                  ;;
                * )
                   echo "Unimplemented option: -$OPTARG" >&2;
                   exit 1
                  ;;
        esac
done
shift $((OPTIND-1))

# Check mandatory options
if [ $rflag != 1 ]
then
    echo "Error: -U option must be set" >&2
    exit 1
fi


#================================================================
# FUNCTIONS
#================================================================

#CHECK DEPENDENCIES
#This function check all dependencies listed and exits if any is missing
check_dependencies() {
	echo "- Checking dependencies...."
        missing_dependencies=0
        for command in "$@"; do
                if ! [ -x "$(which $command 2> /dev/null)" ]; then
                        echo "Error: Please install $command or make sure it is in your path" >&2
                        let missing_dependencies++
                else
                        echo "$command installed"
                fi
        done

        if [ $missing_dependencies -gt 0 ]; then
                echo "$missing_dependencies missing dependencies, aborting execution" >&2
                exit 1
	else
		echo "Finish checking dependencies. "
    fi
}


install() {
        echo "Installing vim config files"
        cp -r ./vim/.vim /home/$user/
        cp ./vim/.vimrc /home/$user/

        echo "Installing zsh and oh-my-zsh config files"
        cp -r ./zsh/.oh-my-zsh /home/$user/
        cp ./zsh/.zshrc /home/$user

        echo "Copying custom theme to custom folder in .oh-my-zsh"
        cp ./zsh/custom_themes/cleanCustom-theme /home/$user/.oh-my-zsh/custom

        echo "Changing username in config files"
        sed -i "s/##USER##/$user/g" /home/$user/.zshrc
        sed -i "s/##USER##/$user/g" /home/$user/.vimrc

}

uninstall() {

	## Ask user for confirmation
	read -p "Are you sure you want to delete .vimrc,.vim,.oh-my-zsh,.zshrc in /home/$user? [Yy] " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Uninstalling vim config files for user $user"
        	rm -f /home/$user/.vimrc
		rm -rf /home/$user/.vim

       		echo "Uninstalling zsh and oh-my-zsh config files for user $user"
        	rm -rf /home/$user/.oh-my-zsh
        	rm -f /home/$user/.zshrc
	fi
}

update() {

        echo "Updating vim config files"
        cp -r ./vim/.vim /home/$user/
        cp ./vim/.vimrc /home/$user/

        echo "Updating zsh and oh-my-zsh config files"
        cp -r ./zsh/.oh-my-zsh /home/$user/
        cp ./zsh/.zshrc /home/$user

        echo "Copying custom theme to custom folder in .oh-my-zsh"
        cp ./zsh/custom_themes/cleanCustom-theme /home/$user/.oh-my-zsh/custom

        echo "Changing username in config files"
        sed -i "s/##USER##/$user/g" /home/$user/.zshrc
	sed -i "s/##USER##/$user/g" /home/$user/.vimrc
}

#================================================================
# MAIN_BODY
#================================================================

check_dependencies zsh vimx

if [ $uninstall = true ]; then
        uninstall
elif [ $update = true ];then
        update
else
        install
fi
