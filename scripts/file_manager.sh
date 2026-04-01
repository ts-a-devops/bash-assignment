#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_ROOT/logs/file_manager.log"

action=$1
file1=$2
file2=$3

case $action in
    create)
        if [[ -e "$file1" ]]; then
            echo "File already exists!"
        else
            touch "$file1"
            echo "Created $file1"
            echo "$(date): Created $file1" >> "$LOG_FILE"
        fi
        ;;
    
    delete)
        if [[ -e "$file1" ]]; then
            rm "$file1"
            echo "Deleted $file1"
            echo "$(date): Deleted $file1" >> "$LOG_FILE"
        else
            echo "File not found!"
        fi
        ;;
    
    list)
        ls -l
        ;;
    
    rename)
        if [[ -e "$file1" ]]; then
            mv "$file1" "$file2"
            echo "Renamed $file1 to $file2"
            echo "$(date): Renamed $file1 to $file2" >> "$LOG_FILE"
        else
            echo "File not found!"
        fi
        ;;
    
    *)
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
