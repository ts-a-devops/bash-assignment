#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

ACTION=$1
FILE1=$2
FILE2=$3

case $ACTION in
    create)
        if [[ -e "$FILE1" ]]; then
            echo "File already exists!"
        else
            touch "$FILE1"
            echo "File created: $FILE1"
            echo "$(date) - Created $FILE1" >> "$LOG_FILE"
        fi
        ;;
    delete)
        if [[ -e "$FILE1" ]]; then
            rm "$FILE1"
            echo "File deleted: $FILE1"
            echo "$(date) - Deleted $FILE1" >> "$LOG_FILE"
        else
            echo "File does not exist!"
        fi
        ;;
    list)
        ls -lh
        ;;
    rename)
        if [[ -e "$FILE1" ]]; then
            mv "$FILE1" "$FILE2"
            echo "Renamed $FILE1 to $FILE2"
            echo "$(date) - Renamed $FILE1 to $FILE2" >> "$LOG_FILE"
        else
            echo "File does not exist!"
        fi
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
