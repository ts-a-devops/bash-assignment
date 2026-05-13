#!/bin/bash

# Create file manager that supports create, delete, list and rename


LOG_FILE="logs/file_manager.log"
timestamp=$(date '+%a-%Y-%m-%d %T')

# Create Log file if it doesn't exist
if [[ ! -f "$LOG_FILE" ]]
then
    touch "$LOG_FILE"
fi


# Receive the file parameters
action=$1
filename=$2
new_filename=$3 # For renaming files

# Validates that action and filename is not empty
if [[ -z "$action" || -z "$filename" ]]
then
    echo "Input the right syntax. i.e. $0 <action> <filename>"
    exit
fi


# Functions for all actions/commands
create() {
    if [[ -f "$filename" ]]
    then
        echo "[$timestamp] CREATE: File cannot be created! $filename already exists!"
	exit 0
    else
        touch "$filename"
	echo "[$timestamp] CREATE: $filename has been successfully created"
    fi
}

delete() {
    if [[ ! -f "$filename" ]]
    then
        echo "[$timestamp] DELETE: File cannot be removed! $filename does not exists!"
	exit 0
    else
        rm -i "$filename"
        echo "[$timestamp] DELETE: Successfully deleted $filename"
    fi
}

list() {
    if [[ ! -f "$filename" ]]
    then
        echo "[$timestamp] LIST: File cannot be viewed! $filename does not exists!"
	exit 0
    else
        ls -l "$filename"
        echo "[$timestamp] LIST: List command for $filename is successful!"
    fi
}

rename() {
    if [[ ! -f "$filename" ]]
    then
        echo "[$timestamp] RENAME: File cannot be renamed! $filename does not exist!"
	exit 0
    elif [[ -z "$new_filename" ]]
    then
        echo "[$timestamp] RENAME: Input the correct syntax. i.e. rename <filename> <new_filename>"
	exit 0
    elif [[ -f "$new_filename" ]]
    then
        echo "[$timestamp] RENAME: File cannot be renamed! $new_filename already exists!"
	exit 0
    else
        mv "$filename" "$new_filename"
	echo "[$timestamp] RENAME: $filename has been renamed to $new_filename successfully"
    fi
}


# Swtch cases for the commands and log actions
{
case "$action" in
    "create")
        create
        ;;
    "delete")
	delete
	;;
    "list")
	list
	;;
    "rename")
	rename
	;;
    *)
	echo "Command doesn't exist. Supported commands are: create, delete, list and rename"
	;;
esac
} | tee -a "$LOG_FILE"
