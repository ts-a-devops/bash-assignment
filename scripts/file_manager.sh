#!/bin/bash

LOG_FILE="logs/file_manager.log"

# Ensure logs directory exists
mkdir -p logs

# Function to log actions
log_action() {
    local message="$1"
    echo "$(date) - $message" >> "$LOG_FILE"
}

# Check for at least 2 arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 {create|delete|list|rename} <filename> [newname]"
    exit 1
fi

COMMAND=$1
FILE=$2

case $COMMAND in
    create)
        # Auto-rename if file exists
        base="$FILE"
        ext=""
        if [[ "$FILE" == *.* ]]; then
            base="${FILE%.*}"
            ext=".${FILE##*.}"
        fi

        counter=1
        newfile="$FILE"
        while [ -e "$newfile" ]; do
            newfile="${base}_$counter$ext"
            ((counter++))
        done

        touch "$newfile"
        echo "File created: $newfile"
        log_action "CREATE: $newfile"
        ;;

    delete)
        if [ ! -e "$FILE" ]; then
            echo "Error: $FILE does not exist."
            log_action "DELETE FAILED: $FILE does not exist"
        else
            rm -i "$FILE"
            echo "File deleted: $FILE"
            log_action "DELETE: $FILE"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls -lah
        log_action "LIST directory"
        ;;

    rename)
        NEW_NAME=$3
        if [ -z "$NEW_NAME" ]; then
            echo "Error: You must provide a new name for the file."
            exit 1
        fi
        if [ ! -e "$FILE" ]; then
            echo "Error: $FILE does not exist."
            log_action "RENAME FAILED: $FILE does not exist"
        elif [ -e "$NEW_NAME" ]; then
            echo "Error: $NEW_NAME already exists. Aborting."
            log_action "RENAME FAILED: $NEW_NAME already exists"
        else
            mv "$FILE" "$NEW_NAME"
            echo "File renamed from $FILE to $NEW_NAME"
            log_action "RENAME: $FILE -> $NEW_NAME"
        fi
        ;;

    *)
        echo "Unknown command: $COMMAND"
        echo "Usage: $0 {create|delete|list|rename} <filename> [newname]"
        exit 1
        ;;
esac
