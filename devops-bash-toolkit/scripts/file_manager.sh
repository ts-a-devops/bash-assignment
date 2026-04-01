#!/bin/bash

LOG_FILE="../logs/file_manager.log"
mkdir -p ../logs

ACTION=$1
FILE1=$2
FILE2=$3

log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

case $ACTION in
    create)
        if [ -e "$FILE1" ]; then
            echo "File already exists!"
        else
            touch "$FILE1"
            echo "File created: $FILE1"
            log_action "Created $FILE1"
        fi
        ;;
        
    delete)
        if [ -e "$FILE1" ]; then
            rm "$FILE1"
            echo "File deleted: $FILE1"
            log_action "Deleted $FILE1"
        else
            echo "File not found!"
        fi
        ;;
        
    list)
        ls
        log_action "Listed files"
        ;;
        
    rename)
        if [ -e "$FILE1" ]; then
            mv "$FILE1" "$FILE2"
            echo "Renamed $FILE1 to $FILE2"
            log_action "Renamed $FILE1 to $FILE2"
        else
            echo "File not found!"
        fi
        ;;
        
    *)
        echo "Usage: ./file_manager.sh {create|delete|list|rename} filename"
        ;;
esac
