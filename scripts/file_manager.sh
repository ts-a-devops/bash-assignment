#!/bin/bash

# Ensure logs directory exists
mkdir -p logs

# Log file path
LOG_FILE="logs/file_manager.log"

# Read command-line arguments
action=$1       # Operation (create, delete, list, rename)
file=$2         # Target file
newname=$3      # New name (for rename)

# Handle different actions using case statement
case "$action" in

    create)
        # Ensure filename is provided
        if [[ -z "$file" ]]; then
            echo "Provide a filename."
            exit 1
        fi

        # Prevent overwriting existing file
        if [[ -f "$file" ]]; then
            echo "File already exists."
        else
            touch "$file"
            echo "Created $file"
            echo "$(date): Created $file" >> "$LOG_FILE"
        fi
        ;;

    delete)
        # Delete file if it exists
        if [[ -f "$file" ]]; then
            rm "$file"
            echo "Deleted $file"
            echo "$(date): Deleted $file" >> "$LOG_FILE"
        else
            echo "File not found."
        fi
        ;;

    list)
        # List files in current directory
        ls
        echo "$(date): Listed files" >> "$LOG_FILE"
        ;;

    rename)
        # Ensure both old and new filenames are provided
        if [[ -z "$file" || -z "$newname" ]]; then
            echo "Provide old and new filename."
            exit 1
        fi

        # Rename file if it exists
        if [[ -f "$file" ]]; then
            mv "$file" "$newname"
            echo "Renamed $file to $newname"
            echo "$(date): Renamed $file to $newname" >> "$LOG_FILE"
        else
            echo "File not found."
        fi
        ;;

    *)
        # Handle invalid commands
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
