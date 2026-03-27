#!/bin/bash
# scripts/file_manager.sh
LOG_FILE="logs/file_manager.log"
mkdir -p logs

COMMAND=$1
FILENAME=$2
NEW_NAME=$3

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ACTION: $1 | FILE: $2" >> "$LOG_FILE"
}

case $COMMAND in
    create)
        if [ -z "$FILENAME" ]; then
            echo "Error: Please provide a filename."
        elif [ -f "$FILENAME" ]; then
            echo "Error: File '$FILENAME' already exists. Prevented overwriting."
        else
            touch "$FILENAME"
            echo "File '$FILENAME' created successfully."
            log_action "CREATE" "$FILENAME"
        fi
        ;;
    delete)
        if [ -f "$FILENAME" ]; then
            rm "$FILENAME"
            echo "File '$FILENAME' deleted."
            log_action "DELETE" "$FILENAME"
        else
            echo "Error: File '$FILENAME' does not exist."
        fi
        ;;
    list)
        echo "Listing files in current directory:"
        ls -p | grep -v /
        log_action "LIST" "N/A"
        ;;
    rename)
        if [ -f "$FILENAME" ] && [ ! -z "$NEW_NAME" ]; then
            mv "$FILENAME" "$NEW_NAME"
            echo "File '$FILENAME' renamed to '$NEW_NAME'."
            log_action "RENAME" "$FILENAME to $NEW_NAME"
        else
            echo "Error: Ensure the file exists and you provided a new name."
        fi
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [newname]"
        ;;
esac
