#!/bin/bash

mkdir -p logs

LOG_FILE="logs/file_manager.log"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

log_action() {
    echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

case "$1" in
    create)

	    
if [ -z "$2" ]; then
    echo "Error: Please provide a filename"
    exit 1
fi


if [ -e "$2" ]; then
    echo "Error: File already exists!"
    log_action "CREATE FAILED - $2 already exists"
else
    touch "$2"
    echo "File '$2' created successfully"
    log_action "CREATE - $2"
fi 
;;

delete)

	
if [ -z "$2" ]; then
	echo "Error: Please provide a filename"
	exit 1
fi

 if [ -e "$2" ]; then

	 rm "$2"
	 echo "File '$2' deleted successfully"
	 log_action "DELETE - $2"
 else
	 echo "Error: File does not exist"
	 log_action "DELETE FAILED - $2 not found"
 fi
 ;;

list)
	 ls -lh
	 log_action "LIST files"
         ;;
rename)
if [ -z "$2" ] || [ -z "$3" ]; then
        echo "Error: Provide old and new filenames"
	exit 1
fi

if [ ! -e "$2" ]; then
	echo "Error: Source file does not exist"
	log_action "RENAME FAILED - $2 not found"
elif [ -e "$3" ]; then
	echo "Error: Target file already exists"
	log_action "RENAME FAILED - $3 already exists"
else 
	mv "$2" "$3"
	echo "Renamed '$2' to '$3'"
	log_action "RENAME - $2 to $3"
fi
;;

  *)
	   echo "Usage:"
	   echo "./file_manager.sh create <filename>"
	   echo "./file_manager.sh delete <filename>"
	   echo "./file_manager.sh list"
	   echo "./file_manager.sh rename <oldname> <newname>"
;;

esac


