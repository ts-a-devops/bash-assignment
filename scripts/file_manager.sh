#!/bin/bash

LOG_FILE="../logs/file_manager.log"

COMMAND=$1
FILE=$2
NEW_NAME=$3

case $COMMAND in

create)
    if [ -f "$FILE" ]; then
        echo "File already exists!"
    else
        touch "$FILE"
        echo "Created $FILE" | tee -a "$LOG_FILE"
    fi
    ;;

delete)
    if [ -f "$FILE" ]; then
        rm "$FILE"
        echo "Deleted $FILE" | tee -a "$LOG_FILE"
    else
        echo "File does not exist!"
    fi
    ;;

list)
    ls
    echo "Listed files" >> "$LOG_FILE"
    ;;

rename)
    if [ -f "$FILE" ]; then
        mv "$FILE" "$NEW_NAME"
        echo "Renamed $FILE to $NEW_NAME" | tee -a "$LOG_FILE"
    else
        echo "File does not exist!"
    fi
    ;;

*)
    echo "Invalid command"
    echo "Usage:"
    echo "./file_manager.sh create filename"
    echo "./file_manager.sh delete filename"
    echo "./file_manager.sh list"
    echo "./file_manager.sh rename oldname newname"
    ;;
esac
