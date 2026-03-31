#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

action="$1"

case "$action" in
    create)
        file="$2"
        if [[ -e "$file" ]]; then
            echo "Error: File already exists" | tee -a "$LOG_FILE"
        else
            touch "$file"
            echo "File '$file' created successfully" | tee -a "$LOG_FILE"
        fi
        ;;
    delete)
        file="$2"
        if [[ -e "$file" ]]; then
            rm -f "$file"
            echo "File '$file' deleted successfully" | tee -a "$LOG_FILE"
        else
            echo "Error: File does not exist" | tee -a "$LOG_FILE"
        fi
        ;;
    list)
        dir="${2:-.}"
        ls -l "$dir" | tee -a "$LOG_FILE"
        ;;
    rename)
        old_name="$2"
        new_name="$3"
        if [[ ! -e "$old_name" ]]; then
            echo "Error: File does not exist" | tee -a "$LOG_FILE"
        elif [[ -e "$new_name" ]]; then
            echo "Error: Target file already exists" | tee -a "$LOG_FILE"
        else
            mv "$old_name" "$new_name"
            echo "Renamed '$old_name' to '$new_name'" | tee -a "$LOG_FILE"
        fi
        ;;
    *)
        echo "Usage:"
        echo "./scripts/file_manager.sh create <filename>"
        echo "./scripts/file_manager.sh delete <filename>"
        echo "./scripts/file_manager.sh list [directory]"
        echo "./scripts/file_manager.sh rename <old_name> <new_name>"
        ;;
esac
