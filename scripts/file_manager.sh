
#!/bin/bash

# Setting up log directory and file
LOG_FILE="../logs/file_manager.log"

ACTION=$1
FILE1=$2
FILE2=$3

case "$ACTION" in
    create)
        if [[ -z "$FILE1" ]]; then
	    echo "ERROR: File name not provided for creation" | tee -a "$LOG_FILE"
	    exit 1
	fi

	if [[ -e "$FILE1" ]]; then
	    echo "ERROR: file $FILE1 already exits" | tee -a "$LOG_FILE"
	else
	    touch "$FILE1"
	    echo "SUCCESS: File $FILE1 created" | tee -a "$LOG_FILE"
	fi
	;;

    delete)
        if [[ -z "$FILE1" ]]; then
	    echo "ERROR: No filename provided to delete" | tee -a "$LOG_FILE"
	    exit 1
	fi

	if [[ -e "$FILE1" ]]; then
	    rm "$FILE1"
	    echo "SUCCESS: File '$FILE1' deleted" | tee -a "$LOG_FILE"
	else
	    echo "ERROR: File '$FILE1' does not exist" | tee -a "$LOG_FILE"
	fi
	;;

    list)
        echo "Listing files in directory" | tee -a "$LOG_FILE"
	ls | tee -a "$LOG_FILE"
	;;

    rename)
        if [[ -z "$FILE1" ]] || [[ -z "$FILE2" ]]; then
	    echo "ERROR: Provide old and new filenames to rename" | tee -a "$LOG_FILE"
	    exit 1
	fi

	if [[ ! -e "$FILE1" ]]; then
	    echo "ERROR: File '$FILE1' does not exist" | tee -a "$LOG_FILE"
	elif [[ -e "$FILE2" ]]; then
	    echo "ERROR: Target file '$FILE2' already exists" | tee -a "$LOG_FILE"
	else
	    mv "$FILE1" "$FILE2"
	    echo "Sucessfully renamed '$FILE1' TO '$FILE2'" | tee -a "$LOG_FILE"
	fi
	;;

    *)
        echo "Usage:" | tee -a "$LOG_FILE"
	echo "./file_manager.sh create <filename>" | tee -a "$LOG_FILE"
	echo "./file_manager.sh delete <filename>" | tee -a "$LOG_FILE"
	echo "./file_manager.sh list" | tee -a "$LOG_FILE"
	echo "./file_manager.sh rename <oldname> <newname>" | tee -a "$LOG_FILE"
	;;
esac
