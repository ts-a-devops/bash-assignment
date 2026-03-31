


#!/bin/bash

set -euo pipefail

# Ensure logs directory exists
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# Function for logging
log_action() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Check if at least one argument is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 {create|delete|list|rename} [filename]"
    exit 1
fi

COMMAND="$1"

case "$COMMAND" in

    create)
        FILE="$2"

        if [[ -z "${FILE:-}" ]]; then
            echo "Error: No filename provided."
            log_action "CREATE - FAILED - No filename provided"
            exit 1
        fi

        if [[ -e "$FILE" ]]; then
            echo "Error: File already exists."
            log_action "CREATE $FILE - FAILED - Already exists"
        else
            touch "$FILE"
            echo "File '$FILE' created."
            log_action "CREATE $FILE - SUCCESS"
        fi
        ;;

    delete)
        FILE="$2"

        if [[ -z "${FILE:-}" ]]; then
            echo "Error: No filename provided."
            log_action "DELETE - FAILED - No filename provided"
            exit 1
        fi

        if [[ ! -e "$FILE" ]]; then
            echo "Error: File does not exist."
            log_action "DELETE $FILE - FAILED - Not found"
        else
            rm "$FILE"
            echo "File '$FILE' deleted."
            log_action "DELETE $FILE - SUCCESS"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls -lh
        log_action "LIST - SUCCESS"
        ;;

    rename)
        OLD_NAME="$2"
        NEW_NAME="$3"

        if [[ -z "${OLD_NAME:-}" || -z "${NEW_NAME:-}" ]]; then
            echo "Error: Provide both old and new filenames."
            log_action "RENAME - FAILED - Missing arguments"
            exit 1
        fi

        if [[ ! -e "$OLD_NAME" ]]; then
            echo "Error: Source file does not exist."
            log_action "RENAME $OLD_NAME -> $NEW_NAME - FAILED - Source missing"
        elif [[ -e "$NEW_NAME" ]]; then
            echo "Error: Target file already exists."
            log_action "RENAME $OLD_NAME -> $NEW_NAME - FAILED - Target exists"
        else
            mv "$OLD_NAME" "$NEW_NAME"
            echo "Renamed '$OLD_NAME' to '$NEW_NAME'."
            log_action "RENAME $OLD_NAME -> $NEW_NAME - SUCCESS"
        fi
        ;;

    *)
        echo "Invalid command. Use: create | delete | list | rename"
        log_action "INVALID COMMAND: $COMMAND"
        exit 1
        ;;

esac
