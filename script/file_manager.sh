#!/bin/bash

# Setup logging
LOG_FILE="logs/file_manager.log"
mkdir -p logs

# Capture the action and the filenames
ACTION=$1
FILE1=$2
FILE2=$3

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ACTION: $1" >> "$LOG_FILE"
}

case "$ACTION" in
    create)
        if [ -e "$FILE1" ]; then
            echo "Error: File '$FILE1' already exists. Prevented overwrite."
        else
            touch "$FILE1"
            echo "File '$FILE1' created successfully."
            log_action "Created $FILE1"
        fi
        ;;

    delete)
        if [ -f "$FILE1" ]; then
            rm "$FILE1"
            echo "File '$FILE1' deleted."
            log_action "Deleted $FILE1"
        else
            echo "Error: File '$FILE1' not found."
        fi
        ;;

    list)
        echo "Current files in directory:"
        ls -F
        log_action "Listed files"
        ;;

    rename)
        if [ ! -f "$FILE1" ]; then
            echo "Error: Source file '$FILE1' does not exist."
        elif [ -e "$FILE2" ]; then
            echo "Error: Target name '$FILE2' already exists. Prevented overwrite."
        else
            mv "$FILE1" "$FILE2"
            echo "Renamed '$FILE1' to '$FILE2'."
            log_action "Renamed $FILE1 to $FILE2"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [new_filename]"
        ;;
esac
