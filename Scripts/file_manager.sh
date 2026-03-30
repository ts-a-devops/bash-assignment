#!/bin/bash

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

COMMAND=$1
ARG1=$2
ARG2=$3

case "$COMMAND" in
    create)
        if [[ -e "$ARG1" ]]; then
            echo "Error: '$ARG1' already exists. Overwrite prevented."
        else
            touch "$ARG1" && echo "File '$ARG1' created."
            log_action "CREATED: $ARG1"
        fi
        ;;

    delete)
        if [[ -f "$ARG1" ]]; then
            rm "$ARG1" && echo "File '$ARG1' deleted."
            log_action "DELETED: $ARG1"
        else
            echo "Error: File '$ARG1' does not exist."
        fi
        ;;

    list)
        echo "Listing files in current directory:"
        ls -F
        log_action "LISTED files"
        ;;

    rename)
        if [[ ! -f "$ARG1" ]]; then
            echo "Error: Source file '$ARG1' does not exist."
        elif [[ -e "$ARG2" ]]; then
            echo "Error: Target name '$ARG2' already exists. Rename aborted."
        else
            mv "$ARG1" "$ARG2" && echo "Renamed '$ARG1' to '$ARG2'."
            log_action "RENAMED: $ARG1 to $ARG2"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [newfilename]"
        ;;
esac
