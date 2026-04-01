#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

ACTION=$1
FILE=$2
NEWNAME=$3

case $ACTION in
    create)
        if [ -f "$FILE" ]; then
            echo "File already exists" | tee -a "$LOG_FILE"
        else
            touch "$FILE"
            echo "File $FILE created" | tee -a "$LOG_FILE"
        fi
        ;;
    delete)
        if [ -f "$FILE" ]; then
            rm "$FILE"
            echo "File $FILE deleted" | tee -a "$LOG_FILE"
        else
            echo "File not found" | tee -a "$LOG_FILE"
        fi
        ;;
    list)
        ls | tee -a "$LOG_FILE"
        ;;
    rename)
        if [ -f "$FILE" ]; then
            mv "$FILE" "$NEWNAME"
            echo "File renamed to $NEWNAME" | tee -a "$LOG_FILE"
        else
            echo "File not found" | tee -a "$LOG_FILE"
        fi
        ;;
    *)
        echo "Invalid command" | tee -a "$LOG_FILE"
        ;;
esac