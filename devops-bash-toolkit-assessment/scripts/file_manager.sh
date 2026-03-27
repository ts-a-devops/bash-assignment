#!/bin/bash

# 1. Setup Logging
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

# Ensure log directory exists
[ ! -d "$LOG_DIR" ] && mkdir "$LOG_DIR"

# Function to log actions with timestamp
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 2. Command Processing
COMMAND=$1
ARG1=$2
ARG2=$3

case $COMMAND in
    create)
        if [ -z "$ARG1" ]; then
            echo "Error: Please specify a filename. Usage: ./file_manager.sh create <file>"
        elif [ -e "$ARG1" ]; then
            echo "Error: File '$ARG1' already exists. Overwrite prevented."
        else
            touch "$ARG1"
            echo "File '$ARG1' created successfully."
            log_action "CREATED: $ARG1"
        fi
        ;;

    delete)
        if [ -f "$ARG1" ]; then
            rm "$ARG1"
            echo "File '$ARG1' deleted."
            log_action "DELETED: $ARG1"
        else
            echo "Error: File '$ARG1' not found."
        fi
        ;;

    list)
        echo "Listing files in current directory:"
        ls -F | grep -v / # List files only, not directories
        log_action "LISTED: Current directory"
        ;;

    rename)
        if [ -z "$ARG1" ] || [ -z "$ARG2" ]; then
            echo "Usage: ./file_manager.sh rename <old_name> <new_name>"
        elif [ ! -f "$ARG1" ]; then
            echo "Error: Source file '$ARG1' does not exist."
        elif [ -e "$ARG2" ]; then
            echo "Error: Cannot rename. Destination '$ARG2' already exists."
        else
            mv "$ARG1" "$ARG2"
            echo "Renamed '$ARG1' to '$ARG2'."
            log_action "RENAMED: $ARG1 to $ARG2"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename}"
        echo "Example: ./file_manager.sh create test.txt"
        ;;
esac
