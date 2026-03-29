#!/bin/bash

# A script to manage files (create, delete, list, rename).
# Log all actions to logs/file_manager.log

mkdir -p logs
LOG_FILE="logs/file_manager.log"

usage() {
    echo "Usage: $0 {create|delete|list|rename} [filename] [new_filename]"
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

ACTION=$1
FILE_NAME=$2
NEW_FILE_NAME=$3

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Action: $1, Target: $2" >> "$LOG_FILE"
}

case "$ACTION" in
    create)
        if [ -z "$FILE_NAME" ]; then
            echo "Error: Filename required for create."
            usage
        fi
        if [ -f "$FILE_NAME" ]; then
            echo "Error: File '$FILE_NAME' already exists. Action aborted."
        else
            touch "$FILE_NAME"
            echo "File '$FILE_NAME' created."
            log_action "CREATE" "$FILE_NAME"
        fi
        ;;
    delete)
        if [ -z "$FILE_NAME" ]; then
            echo "Error: Filename required for delete."
            usage
        fi
        if [ -f "$FILE_NAME" ]; then
            rm "$FILE_NAME"
            echo "File '$FILE_NAME' deleted."
            log_action "DELETE" "$FILE_NAME"
        else
            echo "Error: File '$FILE_NAME' not found."
        fi
        ;;
    list)
        echo "Listing files in current directory:"
        ls -F
        log_action "LIST" "$(pwd)"
        ;;
    rename)
        if [ -z "$FILE_NAME" ] || [ -z "$NEW_FILE_NAME" ]; then
            echo "Error: Both old and new filenames required for rename."
            usage
        fi
        if [ ! -f "$FILE_NAME" ]; then
            echo "Error: File '$FILE_NAME' not found."
        elif [ -f "$NEW_FILE_NAME" ]; then
            echo "Error: Target file '$NEW_FILE_NAME' already exists. Action aborted."
        else
            mv "$FILE_NAME" "$NEW_FILE_NAME"
            echo "File '$FILE_NAME' renamed to '$NEW_FILE_NAME'."
            log_action "RENAME" "$FILE_NAME to $NEW_FILE_NAME"
        fi
        ;;
    *)
        echo "Error: Invalid action '$ACTION'."
        usage
        ;;
esac
