#!/bin/bash

LOG_FILE="logs/file_manager.log"
mkdir -p logs

# Function to log actions with a timestamp
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Capture the command and arguments
COMMAND=$1
ARG1=$2
ARG2=$3

case "$COMMAND" in
    create)
        if [[ -e "$ARG1" ]]; then
            echo "Error: File '$ARG1' already exists."
        else
            touch "$ARG1"
            echo "File '$ARG1' created."
            log_action "CREATED: $ARG1"
        fi
        ;;

    delete)
        if [[ -f "$ARG1" ]]; then
            rm "$ARG1"
            echo "File '$ARG1' deleted."
            log_action "DELETED: $ARG1"
        else
            echo "Error: File '$ARG1' does not exist."
        fi
        ;;

    list)
        echo "Listing files in current directory:"
        ls -F
        log_action "LISTED: Directory contents"
        ;;

    rename)
        if [[ ! -e "$ARG1" ]]; then
            echo "Error: Source file '$ARG1' does not exist."
        elif [[ -e "$ARG2" ]]; then
            echo "Error: Target name '$ARG2' already exists. Prevented overwrite."
        else
            mv "$ARG1" "$ARG2"
            echo "Renamed '$ARG1' to '$ARG2'."
            log_action "RENAMED: $ARG1 to $ARG2"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [newname]"
        ;;
esac
