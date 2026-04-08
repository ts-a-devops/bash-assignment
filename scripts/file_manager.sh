#!/bin/bash

LOG_FILE="../logs/file_manager.log"

mkdir -p "$(dirname "$LOG_FILE")"

COMMAND=$1
FILE1=$2
FILE2=$3

#current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Check which command to execute
case "$COMMAND" in
    create)
        if [ -z "$FILE1" ]; then
            echo "Error: No file name provided."
        elif [ -f "$FILE1" ]; then
            echo "Error: '$FILE1' already exists."
        else
            touch "$FILE1"
            echo "$TIMESTAMP create $FILE1" >> "$LOG_FILE"
            echo "Created '$FILE1'."
        fi
        ;;
    delete)
        if [ -z "$FILE1" ]; then
            echo "Error: No file name provided."
        elif [ ! -f "$FILE1" ]; then
            echo "Error: '$FILE1' does not exist."
        else
            rm "$FILE1"
            echo "$TIMESTAMP delete $FILE1" >> "$LOG_FILE"
            echo "Deleted '$FILE1'."
        fi
        ;;
    rename)
        if [ -z "$FILE1" ] || [ -z "$FILE2" ]; then
            echo "Error: Provide both old and new file names."
        elif [ ! -f "$FILE1" ]; then
            echo "Error: '$FILE1' does not exist."
        elif [ -f "$FILE2" ]; then
            echo "Error: '$FILE2' already exists."
        else
            mv "$FILE1" "$FILE2"
            echo "$TIMESTAMP rename $FILE1 -> $FILE2" >> "$LOG_FILE"
            echo "Renamed '$FILE1' to '$FILE2'."
        fi
        ;;
    list)
        echo "Files in current directory:"
        ls -lh
        echo "$TIMESTAMP list" >> "$LOG_FILE"
        ;;
    *)
        echo "Usage: $0 {create|delete|rename|list} [file1] [file2]"
        ;;
esac