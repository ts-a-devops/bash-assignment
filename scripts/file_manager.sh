#!/bin/bash

# Task: Log all actions to logs/file_manager.log
# (Using ../logs because we are running from inside the scripts folder)
LOG="../logs/file_manager.log"
mkdir -p ../logs

COMMAND=$1
FILENAME=$2
NEWNAME=$3

case $COMMAND in
    create)
        # Task: Prevent overwriting existing files
        if [ -f "$FILENAME" ]; then
            echo "Error: '$FILENAME' already exists. Overwrite prevented." | tee -a "$LOG"
        else
            touch "$FILENAME"
            echo "SUCCESS: Created file '$FILENAME'" | tee -a "$LOG"
        fi
        ;;
    delete)
        if [ -f "$FILENAME" ]; then
            rm "$FILENAME"
            echo "SUCCESS: Deleted file '$FILENAME'" | tee -a "$LOG"
        else
            echo "Error: '$FILENAME' not found." | tee -a "$LOG"
        fi
        ;;
    list)
        echo "Listing files in current directory:"
        ls -lh
        ;;
    rename)
        if [ -f "$FILENAME" ]; then
            mv "$FILENAME" "$NEWNAME"
            echo "SUCCESS: Renamed '$FILENAME' to '$NEWNAME'" | tee -a "$LOG"
        else
            echo "Error: Source file '$FILENAME' not found." | tee -a "$LOG"
        fi
        ;;
    *)
        # Help message if the user types the wrong command
        echo "Usage: $0 {create|delete|list|rename} [filename] [newname]"
        ;;
esac
