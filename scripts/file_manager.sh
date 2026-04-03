#!/bin/bash

LOG_FILE="../logs/file_manager.log"

action=$1
file=$2

case $action in
    create)
        if [ -f "$file" ]; then
            echo "File already exists!"
        else
            touch "$file"
            echo "$(date): Created $file" >> "$LOG_FILE"
        fi
        ;;
    delete)
        if [ -f "$file" ]; then
            rm "$file"
            echo "$(date): Deleted $file" >> "$LOG_FILE"
        else
            echo "File does not exist!"
        fi
        ;;
    list)
        ls
        ;;
    rename)
        new_name=$3
        mv "$file" "$new_name"
        echo "$(date): Renamed $file to $new_name" >> "$LOG_FILE"
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} filename"
        ;;
esac
