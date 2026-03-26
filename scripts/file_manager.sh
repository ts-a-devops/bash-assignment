#!/bin/bash

LOG_FILE="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Get command and arguments
command=$1
file1=$2
file2=$3

case "$command" in

    create)
        if [[ -z "$file1" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ -e "$file1" ]]; then
            echo "Error: File already exists. Cannot overwrite."
            log_action "CREATE FAILED: $file1 already exists"
        else
            touch "$file1"
            echo "File '$file1' created."
            log_action "CREATED: $file1"
        fi
        ;;

    delete)
        if [[ -z "$file1" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ -e "$file1" ]]; then
            rm "$file1"
            echo "File '$file1' deleted."
            log_action "DELETED: $file1"
        else
            echo "Error: File does not exist."
            log_action "DELETE FAILED: $file1 not found"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls
        log_action "LISTED files in directory"
        ;;

    rename)
        if [[ -z "$file1" || -z "$file2" ]]; then
            echo "Error: Provide old and new filenames."
            exit 1
        fi

        if [[ ! -e "$file1" ]]; then
            echo "Error: Source file does not exist."
            log_action "RENAME FAILED: $file1 not found"
        elif [[ -e "$file2" ]]; then
            echo "Error: Target file already exists."
            log_action "RENAME FAILED: $file2 already exists"
        else
            mv "$file1" "$file2"
            echo "Renamed '$file1' to '$file2'."
            log_action "RENAMED: $file1 to $file2"
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