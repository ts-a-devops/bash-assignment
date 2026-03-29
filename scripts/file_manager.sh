#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/file_manager.log"

command=$1
file=$2

case $command in
    create)
        if [[ -f "$file" ]]; then
            echo "File already exists."
        else
            touch "$file"
            echo "Created $file"
            echo "$(date): Created $file" >> "$LOG_FILE"
        fi
        ;;
    delete)
        if [[ -f "$file" ]]; then
            rm "$file"
            echo "Deleted $file"
            echo "$(date): Deleted $file" >> "$LOG_FILE"
        else
            echo "File does not exist."
        fi
        ;;
    list)
        ls -l
        ;;
    rename)
        new_name=$3
        if [[ -f "$file" ]]; then
            mv "$file" "$new_name"
            echo "Renamed $file to $new_name"
            echo "$(date): Renamed $file to $new_name" >> "$LOG_FILE"
        else
            echo "File does not exist."
        fi
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} filename"
        ;;
esac
