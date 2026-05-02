#!/bin/bash

set -euo pipefail

LOG_FILE="logs/file_manager.log"

mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

show_usage() {
    echo "Usage: $0 <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  create <filename>              - Create a new file"
    echo "  delete <filename>              - Delete a file"
    echo "  list [directory]               - List files in directory (default: current)"
    echo "  rename <old_name> <new_name>   - Rename a file"
    echo ""
}

# Check if command is provided
if [[ $# -lt 1 ]]; then
    echo "Error: No command provided"
    show_usage
    exit 1
fi

COMMAND="$1"

case "$COMMAND" in
    create)
        if [[ $# -lt 2 ]]; then
            echo "Error: Filename required for create command"
            exit 1
        fi
        
        FILENAME="$2"
        
        if [[ -e "$FILENAME" ]]; then
            log_message "ERROR: File already exists: $FILENAME"
            echo "Error: File '$FILENAME' already exists. Use a different name."
            exit 1
        fi
        
        touch "$FILENAME"
        log_message "SUCCESS: Created file: $FILENAME"
        echo "✓ File created: $FILENAME"
        ;;
        
    delete)
        if [[ $# -lt 2 ]]; then
            echo "Error: Filename required for delete command"
            exit 1
        fi
        
        FILENAME="$2"
        
        if [[ ! -e "$FILENAME" ]]; then
            log_message "ERROR: File not found: $FILENAME"
            echo "Error: File '$FILENAME' not found."
            exit 1
        fi
        
        rm "$FILENAME"
        log_message "SUCCESS: Deleted file: $FILENAME"
        echo "✓ File deleted: $FILENAME"
        ;;
        
    list)
        DIRECTORY="${2:-.}"
        
        if [[ ! -d "$DIRECTORY" ]]; then
            log_message "ERROR: Directory not found: $DIRECTORY"
            echo "Error: Directory '$DIRECTORY' not found."
            exit 1
        fi
        
        log_message "SUCCESS: Listed files in: $DIRECTORY"
        echo "Files in $DIRECTORY:"
        ls -lh "$DIRECTORY" || true
        ;;
        
    rename)
        if [[ $# -lt 3 ]]; then
            echo "Error: Old name and new name required for rename command"
            exit 1
        fi
        
        OLD_NAME="$2"
        NEW_NAME="$3"
        
        if [[ ! -e "$OLD_NAME" ]]; then
            log_message "ERROR: File not found: $OLD_NAME"
            echo "Error: File '$OLD_NAME' not found."
            exit 1
        fi
        
        if [[ -e "$NEW_NAME" ]]; then
            log_message "ERROR: Target file already exists: $NEW_NAME"
            echo "Error: File '$NEW_NAME' already exists. Choose a different name."
            exit 1
        fi
        
        mv "$OLD_NAME" "$NEW_NAME"
        log_message "SUCCESS: Renamed '$OLD_NAME' to '$NEW_NAME'"
        echo "✓ File renamed: $OLD_NAME → $NEW_NAME"
        ;;
        
    *)
        echo "Error: Unknown command: $COMMAND"
        show_usage
        exit 1
        ;;
esac

exit 0
