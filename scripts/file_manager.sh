#!/bin/bash

# Create logs directory if it doesn't exist
# mkdir -p logs

LOG_FILE="../logs/file_manager.log"

action=$1
file1=$2

case "$action" in
    create)
        
        if [[ -f "$file1" ]]; then
            echo "Error: File already exists."
        else
            message="File '$file1' created."
            touch "$file1"
            echo "$message"
            echo "$(date '+%Y-%m-%d %H:%M:%S'): $message" >> "$LOG_FILE"
        fi
        ;;

    delete)
       

        if [[ -f "$file1" ]]; then
            message="File '$file1' deleted."
            rm "$file1"
            echo "$message"
            echo "$(date '+%Y-%m-%d %H:%M:%S'): $message" >> "$LOG_FILE"
        else
            echo "Error: File does not exist."
        fi
        ;;

    list)
        echo "Files in current directory:"
        ls -lh
        ;;

    rename)
      NEW_NAME=$3
        
        if [[ ! -e "$file1" ]]; then
            echo "Error: File does not exist."
        else
            message="Renamed '$file1' to '$NEW_NAME'."
            mv "$file1" "$NEW_NAME"
            echo "$message"
            echo "$(date '+%Y-%m-%d %H:%M:%S'): $message" >> "$LOG_FILE"
        fi
        ;;

    *)
        echo "Usage:"
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
