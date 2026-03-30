#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

COMMAND="$1"
FILE="$2"

log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

case "$COMMAND" in
    create)
        if [ -e "$FILE" ]; then
            echo "Error: $FILE already exists."
            log_action "Failed to create $FILE (already exists)"
        else
            touch "$FILE"
            echo "$FILE created."
            log_action "Created $FILE"
        fi
        ;;
    
    delete)
        if [ -e "$FILE" ]; then
            rm "$FILE"
            echo "$FILE deleted."
            log_action "Deleted $FILE"
        else
            echo "Error: $FILE does not exist."
            log_action "Failed to delete $FILE (not found)"
        fi
        ;;
    
    list)
        ls -l
        log_action "Listed files"
        ;;
    
    rename)
        NEW_NAME="$3"
        if [ -e "$FILE" ]; then
            if [ -e "$NEW_NAME" ]; then
                echo "Error: $NEW_NAME already exists."
                log_action "Failed to rename $FILE to $NEW_NAME (exists)"
            else
                mv "$FILE" "$NEW_NAME"
                echo "$FILE renamed to $NEW_NAME."
                log_action "Renamed $FILE to $NEW_NAME"
            fi
        else
            echo "Error: $FILE not found."
            log_action "Failed to rename $FILE (not found)"
        fi
        ;;
    
    *)
        echo "Usage: ./file_manager.sh {create|delete|list|rename} filename"
        ;;
esac
