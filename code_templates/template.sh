#!/bin/bash

# Exit immediately if a pipeline, which may consist of a single simple command, a list,
#or a compound command returns a non-zero status: If errors are not handled by user
set -e

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error when performing parameter expansion.
# An error message will be written to the standard error, and a non-interactive shell will exit
set -u

#Print everything as if it were executed, after substitution and expansion is applied: Debug|log option
set -x

#=============================================================
# HEADER
#=============================================================

#INSTITUTION:ISCIII
#CENTRE:BU-ISCIII
#AUTHOR:
VERSION=1.0 #Version is set in order to be called with -v parameter
#CREATED: 13 March 2018
#REVISION:
#DESCRIPTION:Generic BASH script template. It does guide new BU-ISCII personnel to script propperly in BASH.
#SOURCE_OF_SCRIPT/AKNOWLEDGE:
#https://google.github.io/styleguide/shell.xml
#https://natelandau.com/boilerplate-shell-script-template/
#https://stackoverflow.com/questions/14008125/shell-script-common-template
#getops --long : https://stackoverflow.com/questions/402377/using-getopts-in-bash-shell-script-to-get-long-and-short-command-line-options/28466267#28466267
#							 : https://gist.github.com/adamhotep/895cebf290e95e613c006afbffef09d7
#getops: http://wiki.bash-hackers.org/howto/getopts_tutorial

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
Brief description of script

usage : $0 [-i inputfile] [-o outputfile] [-l ] [-v] [-h] [starting directories]

	-i input file
	-o output file
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
threads=1
rflag=0		# Flag for mandatory options

#PARSE VARIABLE ARGUMENTS WITH getops
#common example with letters, for long options check longopts2getopts.sh
while getopts ":i:o:vh" opt; do
	case $opt in
		i )
			rflag=$(($rflag+1));input_dir=$OPTARG
			;;
		o )
			output_dir=$OPTARG
			;;
		h )
		  	usage
		  	exit 1
		  ;;
		f )
			if [[ ${@:$OPTIND} =~ ^[0-9]+$ ]];then
        		offrate=${@:$OPTIND}
        		OPTIND=$((OPTIND+1))
      		else
         		offrate=1
      		fi
      		;;
		v )
		  echo $VERSION
		  exit 1
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

# Check mandatory options. Change number to number of mandatory fields.
if [ $rflag != 1 ]
then
    echo "Error: -i option must be set" >&2
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

#================================================================
# MAIN_BODY
#================================================================

check_dependencies program


if [ ! $output_dir ]; then
	output_dir=$(dirname $input_file)
	#echo "Default output directory is" $output_dir
	mkdir -p $output_dir
else
	#echo "Output directory is" $output_dir
	mkdir -p $output_dir
fi

if [ ! $filename ]; then
	filename=$(basename $input_file | cut -d. -f1)
fi
