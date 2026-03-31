#!/bin/bash

LOG_FILE="../logs/file_manager.log"
mkdir -p $(dirname "$LOG_FILE")

ACTION=$1
TARGET=$2

# Check if action was provided
if [[ -z "$ACTION" ]]; then
    echo "Error: No command provided."
    echo "Usage: ./file_manager.sh [create|delete|list|rename] [filename]"
    exit 1
fi

# Actions
case "$ACTION" in
    create)
        if [[ -z "$TARGET" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi
        if [[ -f "$TARGET" ]]; then
            echo "Error: File '$TARGET' already exists. Overwriting not allowed."
            exit 1
        fi
        touch "$TARGET"
        echo "File '$TARGET' created successfully."
        echo "$(date): CREATE - $TARGET" >> "$LOG_FILE"
        ;;

    delete)
        if [[ -z "$TARGET" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi
        if [[ ! -f "$TARGET" ]]; then
            echo "Error: File '$TARGET' does not exist."
            exit 1
        fi
        rm "$TARGET"
        echo "File '$TARGET' deleted successfully."
        echo "$(date): DELETE - $TARGET" >> "$LOG_FILE"
        ;;

    list)
        echo "Files in current directory:"
        ls -lh
        echo "$(date): LIST - Directory listed" >> "$LOG_FILE"
        ;;

    rename)
        NEW_NAME=$3
        if [[ -z "$TARGET" || -z "$NEW_NAME" ]]; then
            echo "Error: Please provide current and new filename."
            echo "Usage: ./file_manager.sh rename oldname.txt newname.txt"
            exit 1
        fi
        if [[ ! -f "$TARGET" ]]; then
            echo "Error: File '$TARGET' does not exist."
            exit 1
        fi
        if [[ -f "$NEW_NAME" ]]; then
            echo "Error: File '$NEW_NAME' already exists. Overwriting not allowed."
            exit 1
        fi
        mv "$TARGET" "$NEW_NAME"
        echo "File '$TARGET' renamed to '$NEW_NAME' successfully."
        echo "$(date): RENAME - $TARGET to $NEW_NAME" >> "$LOG_FILE"
        ;;

    *)
        echo "Error: Unknown command '$ACTION'."
        echo "Usage: ./file_manager.sh [create|delete|list|rename] [filename]"
        exit 1
        ;;
esac
