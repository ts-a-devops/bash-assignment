#!/bin/bash

mkdir -p logs

ACTION=$1
FILENAME=$2
NEWNAME=$3
LOG_FILE="logs/file_manager.log"

case "$ACTION" in
    create)
        if [ -z "$FILENAME" ]; then
            echo "Error: No filename provided"
            exit 1
        fi
        if [ -e "$FILENAME" ]; then
            echo "Error: $FILENAME already exists"
            exit 1
        fi
        touch "$FILENAME"
        echo "$(date): Created $FILENAME" | tee -a $LOG_FILE
        ;;
        
    delete)
        if [ -z "$FILENAME" ]; then
            echo "Error: No filename provided"
            exit 1
        fi
        if [ ! -e "$FILENAME" ]; then
            echo "Error: $FILENAME does not exist"
            exit 1
        fi
        rm "$FILENAME"
        echo "$(date): Deleted $FILENAME" | tee -a $LOG_FILE
        ;;
        
    list)
        ls -l
        echo "$(date): Listed files" | tee -a $LOG_FILE
        ;;
        
    rename)
        if [ -z "$FILENAME" ] || [ -z "$NEWNAME" ]; then
            echo "Error: Provide old and new filename"
            exit 1
        fi
        if [ ! -e "$FILENAME" ]; then
            echo "Error: $FILENAME does not exist"
            exit 1
        fi
        mv "$FILENAME" "$NEWNAME"
        echo "$(date): Renamed $FILENAME to $NEWNAME" | tee -a $LOG_FILE
        ;;
        
    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [newname]"
        ;;
esac