#!/bin/bash

ACTION=$1
FILENAME=$2
LOG_FILE="logs/file_manager.log"

# Function to log actions
log_action() {
    echo "$(date): $1" >> $LOG_FILE
}

case $ACTION in
    create)
        if [ -f "$FILENAME" ]; then
            echo "Error: File '$FILENAME' already exists!"
        else
            touch "$FILENAME"
            echo "File '$FILENAME' created successfully."
            log_action "Created $FILENAME"
        fi
        ;;
    delete)
        if [ -f "$FILENAME" ]; then
            rm "$FILENAME"
            echo "File '$FILENAME' deleted."
            log_action "Deleted $FILENAME"
        else
            echo "Error: File '$FILENAME' not found."
        fi
        ;;
    list)
        echo "Listing files in current directory:"
        ls -p | grep -v /
        log_action "Listed files"
        ;;
    rename)
        NEWNAME=$3
        if [ -f "$FILENAME" ]; then
            mv "$FILENAME" "$NEWNAME"
            echo "Renamed '$FILENAME' to '$NEWNAME'."
            log_action "Renamed $FILENAME to $NEWNAME"
        else
            echo "Error: Original file not found."
        fi
        ;;
    *)
        echo "Usage: ./file_manager.sh {create|delete|list|rename} [filename] [newname]"
        ;;
esac

