#!/usr/bin/bash

set -o pipefail

	#Making a log for logging obviously
mkdir -p logs

# $1 is a command, must be a command. $2 must be a file name , has to be a file name. $3 must be a new file name.
		#PLEASE DO NOT FORGET


{
echo
echo "$(date '+%B %d %T')"

case "$1" in
    create)
        if [[ -z "$2" ]]; then
            echo "ERROR: create requires a filename to work. What file do you intend to create, pass it as a second argument."
            exit 1
        fi

        if [[ -e "$2" ]]; then
            echo "ERROR: '$2' already exists. I will not create to prevent overwriting the existing file."
            exit 1
        fi

        if touch "$2"; then
            echo "Voilà! '$2' created"
	else
            echo "ERROR: I have failed to create '$2'"
            exit 1
	fi
        ;;
#----------------------------------------------------------------------------------------------------------------------------------------
    delete)
        if [[ -z "$2" ]]; then
            echo "ERROR: delete requires a filename to work. Whatever file you want to delete pass it as a second argument."
            exit 1
        fi

        if [[ ! -e "$2" ]]; then
            echo "ERROR: I can't delete '$2' because '$2' does not exist."
            exit 1
        fi

	if rm "$2"; then
            echo "Viola! You have just deleted $2. If that was a mistake I hope you had a backup."
	else
	    echo "ERROR: I have failed to delete '$2'"
	    exit 1
	fi
        ;;
#----------------------------------------------------------------------------------------------------------------------------------------
    list)

	if [[ -z "$2" ]]; then
	    echo "ERROR: What do you want me to list?"
	    exit 1
	fi

	if [[ ! -e "$2" ]]; then
	    echo "ERROR: I can't list what does not exist, '$2' does not exist."
	    exit 1
	fi

        if [[ -f "$2" ]]; then
	    echo "This is the content of the file"
	    cat "$2"
	fi

	if [[ -d "$2" ]]; then 
	    echo "These are the files in this directory"
	    ls -l "$2"
	fi
        ;;
#----------------------------------------------------------------------------------------------------------------------------------------
    rename)
        if [[ -z "$2" || -z "$3" ]]; then
            echo "ERROR: rename requires the old name as the second argument and the new name as the third argument."
            exit 1
        fi

        if [[ ! -e "$2" ]]; then
            echo "ERROR: I can't do what you ask of me cause '$2' doesn't exist"
            exit 1
        fi

        if [[ -e "$3" ]]; then
            echo "ERROR: '$3' already exists. I do not wish to overwrite."
            exit 1
        fi

        if mv "$2" "$3"; then
            echo "I have renamed '$2' to '$3'"
	else
	    echo "I have failed to rename '$2'"
        fi
	;;

    *)
        echo "ERROR: Unsupported command. Use: create, delete, list, rename"
        exit 1
        ;;
esac
} | tee -a logs/file_manager.log
