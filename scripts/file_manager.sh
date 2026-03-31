#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

action=$1
file=$2
new_name=$3

case $action in
    create)
        if [ -f "$file" ]; then
            echo "Error: File already exists!"
        else
            touch "$file"
            echo "Created file: $file"
            echo "Created $file" >> "$LOG_FILE"
        fi
        ;;

    delete)
        if [ -f "$file" ]; then
            rm "$file"
            echo "Deleted file: $file"
            echo "Deleted $file" >> "$LOG_FILE"
        else
            echo "Error: File not found!"
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls
        ;;

    rename)
        if [ -f "$file" ]; then
            mv "$file" "$new_name"
            echo "Renamed $file to $new_name"
            echo "Renamed $file to $new_name" >> "$LOG_FILE"
        else
            echo "Error: File not found!"
        fi
        ;;

    *)
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
