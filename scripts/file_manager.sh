#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

ACTION=$1
FILE=$2
NEW_NAME=$3

case $ACTION in
    create)
        if [[ -f "$FILE" ]]; then
            echo "File already exists!" | tee -a $LOG_FILE
        else
            touch "$FILE"
            echo "Created $FILE" | tee -a $LOG_FILE
        fi
        ;;
    delete)
        if [[ -f "$FILE" ]]; then
            rm "$FILE"
            echo "Deleted $FILE" | tee -a $LOG_FILE
        else
            echo "File does not exist!" | tee -a $LOG_FILE
        fi
        ;;
    list)
        ls
        ;;
    rename)
        if [[ -f "$FILE" ]]; then
            mv "$FILE" "$NEW_NAME"
            echo "Renamed $FILE to $NEW_NAME" | tee -a $LOG_FILE
        else
            echo "File does not exist!" | tee -a $LOG_FILE
        fi
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} filename [new_name]"
        ;;
esac
