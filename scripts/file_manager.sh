#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

log_file="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Check if at least one argument is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 {create|delete|list|rename} [filename]"
    exit 1
fi

command=$1

case $command in

    create)
        if [[ -z "$2" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ -e "$2" ]]; then
            echo "Error: File already exists. Cannot overwrite."
            log_action "CREATE FAILED - $2 already exists"
        else
            touch "$2"
            echo "File '$2' created successfully."
            log_action "CREATED - $2"
        fi
        ;;

    delete)
        if [[ -z "$2" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ -e "$2" ]]; then
            rm "$2"
            echo "File '$2' deleted successfully."
            log_action "DELETED - $2"
        else
            echo "Error: File does not exist."
            log_action "DELETE FAILED - $2 not found"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls
        log_action "LISTED files"
        ;;

    rename)
        if [[ -z "$2" || -z "$3" ]]; then
            echo "Error: Please provide old and new filenames."
            exit 1
        fi

        if [[ ! -e "$2" ]]; then
            echo "Error: Source file does not exist."
            log_action "RENAME FAILED - $2 not found"
        elif [[ -e "$3" ]]; then
            echo "Error: Target file already exists. Cannot overwrite."
            log_action "RENAME FAILED - $3 already exists"
        else
            mv "$2" "$3"
            echo "File renamed from '$2' to '$3'."
            log_action "RENAMED - $2 to $3"
        fi
        ;;

    *)
        echo "Invalid command. Use: create, delete, list, or rename."
        exit 1
        ;;

esac