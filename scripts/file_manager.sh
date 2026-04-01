#!/bin/bash
COMMAND=$1
FILENAME=$2
NEW_NAME=$3
LOG_FILE="logs/file_manager.log"

# Ensure logs directory exists
mkdir -p logs

case "$COMMAND" in
    create)
        if [ -e "$FILENAME" ]; then
            echo "Error: File '$FILENAME' already exists. Overwrite prevented." | tee -a "$LOG_FILE"
        else
            touch "$FILENAME"
            echo "Created file: $FILENAME" | tee -a "$LOG_FILE"
        fi
        ;;

    delete)
        if [ -f "$FILENAME" ]; then
            rm "$FILENAME"
            echo "Deleted file: $FILENAME" | tee -a "$LOG_FILE"
        else
            echo "Error: File '$FILENAME' not found." | tee -a "$LOG_FILE"
        fi
        ;;

    list)
        echo "Listing files in current directory:" | tee -a "$LOG_FILE"
        ls -1 | tee -a "$LOG_FILE"
        ;;

    rename)
        if [ -f "$FILENAME" ]; then
            mv "$FILENAME" "$NEW_NAME"
            echo "Renamed '$FILENAME' to '$NEW_NAME'" | tee -a "$LOG_FILE"
        else
            echo "Error: Cannot rename. Source file '$FILENAME' does not exist." | tee -a "$LOG_FILE"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [new_filename]"
        ;;
esac
