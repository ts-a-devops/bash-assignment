#!/bin/bash

#Function for log actions
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1 $2" &>> ../logs/system_report_30_03_2026.log
}

#Function to  create
create() {
    if [[ -z "$2" ]]; then
	echo "PLease specify a file name to create"
    elif [[ -e "$2" ]]; then
	 echo "$2 already exists!"
    else
	 touch "$2"
	 echo "created $2"
	 log_action "$@"
    fi
}

#Function to delete
delete() {
    if [[ -z "$2" ]]; then
        echo "PLease specify a file name to delete"
    elif [[ -e "$2" ]]; then
         rm "$2"
	 echo "deleted $2"
	 log_action "$@"
    else
        echo "There is no file like $2 in this directory"
    fi
}

#Function to list everything in scripts directory
list() {
    ls -l 
    log_action "$1"
}

#Function to rename files from old_name to new_name
rename() {
    if [[ -z "$2" || -z "$3" ]];then
        echo "renaming argument is incomplete: either oldname or newname is missing"
    elif [[ ! -e "$2" ]];then
	 echo "$2 does not exist"
    elif [[ -e "$3" ]];then
         echo "$3 already exist, choose another filename"
    else
        mv "$2" "$3"
        echo "renamed $2 to $3"
        log_action "$1 $2" "$3"
     fi
}

#statements to call each function
if [[ "$1" == create ]];then
    create "$@"
elif [[ "$1" == "delete" ]];then
     delete $@
elif [[ "$1" == "list" ]];then
    list $@
elif [[ "$1" == "rename" ]];then
    rename $@
else
   echo "Error:incorrect command"
fi


