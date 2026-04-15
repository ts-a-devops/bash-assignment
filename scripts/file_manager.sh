#!/bin/bash

LOG_FILE="../logs/file_manager.log"

action=$1
file1=$2
file2=$3

case $action in
    create)
        if [[ -f "$file1" ]]; then
            echo "File already exists!"
        else
            touch "$file1"
            echo "File created: $file1"
        fi
        ;;
    delete)
        if [[ -f "$file1" ]]; then
            rm "$file1"
            echo "File deleted: $file1"
        else
            echo "File not found!"
        fi
        ;;
    list)
        ls
        ;;
    rename)
        if [[ -f "$file1" ]]; then
            mv "$file1" "$file2"
            echo "Renamed to $file2"
        else
            echo "File not found!"
        fi
        ;;
    *)
        echo "Invalid command"
        ;;
esac

# Log action
echo "$(date): $action $file1 $file2" >> "$LOG_FILE"
