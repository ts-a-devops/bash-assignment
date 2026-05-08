#!/bin/bash

# Create logs directory if it doesn't exist
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Convert command to lowercase
COMMAND=$(echo "$1" | tr '[:upper:]' '[:lower:]')

case "$COMMAND" in

    create)
        if [ -z "$2" ]; then
            echo "Error: No filename provided."
            log_action "CREATE failed - No filename provided"
            exit 1
        fi

        if [ -e "$2" ]; then
            echo "Error: File already exists."
            log_action "CREATE failed - File '$2' already exists"
        else
            touch "$2"
            echo "File '$2' created successfully."
            log_action "File '$2' created"
        fi
        ;;

    delete)
        if [ -z "$2" ]; then
            echo "Error: No filename provided."
            log_action "DELETE failed - No filename provided"
            exit 1
        fi

        if [ -e "$2" ]; then
            rm "$2"
            echo "File '$2' deleted successfully."
            log_action "File '$2' deleted"
        else
            echo "Error: File does not exist."
            log_action "DELETE failed - File '$2' not found"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls -1
        log_action "Listed files"
        ;;

    rename)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Error: Provide old and new filenames."
            log_action "RENAME failed - Missing arguments"
            exit 1
        fi

        if [ ! -e "$2" ]; then
            echo "Error: Source file does not exist."
            log_action "RENAME failed - '$2' not found"
        elif [ -e "$3" ]; then
            echo "Error: Target file already exists."
            log_action "RENAME failed - '$3' already exists"
        else
            mv "$2" "$3"
            echo "File renamed from '$2' to '$3'."
            log_action "Renamed '$2' to '$3'"
        fi
        ;;

    *)
        echo "Invalid command."
        echo "Usage:"
        echo "./file_manager.sh create <filename>"
        echo "./file_manager.sh delete <filename>"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename <oldname> <newname>"
        log_action "Invalid command attempted"
        ;;

esac;
