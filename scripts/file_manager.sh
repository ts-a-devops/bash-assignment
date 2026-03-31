#!/bin/bash

# file_manager.sh - File management operations (create, delete, list, rename)

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/file_manager.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to validate command
validate_command() {
    case "$1" in
        create|delete|list|rename)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if command is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <command> [arguments]"
    echo "Commands: create <filename>, delete <filename>, list, rename <old_name> <new_name>"
    exit 1
fi

COMMAND="$1"

# Validate command
if ! validate_command "$COMMAND"; then
    echo "Error: Invalid command '$COMMAND'"
    log_message "Error: Invalid command - $COMMAND"
    exit 1
fi

case "$COMMAND" in
    create)
        if [[ $# -lt 2 ]]; then
            echo "Error: create requires a filename"
            exit 1
        fi
        FILENAME="$2"
        
        if [[ -e "$FILENAME" ]]; then
            echo "Error: File '$FILENAME' already exists"
            log_message "Error: Attempted to create existing file - $FILENAME"
            exit 1
        fi
        
        touch "$FILENAME"
        echo "✓ File '$FILENAME' created successfully"
        log_message "Created file: $FILENAME"
        ;;
    
    delete)
        if [[ $# -lt 2 ]]; then
            echo "Error: delete requires a filename"
            exit 1
        fi
        FILENAME="$2"
        
        if [[ ! -e "$FILENAME" ]]; then
            echo "Error: File '$FILENAME' does not exist"
            log_message "Error: Attempted to delete non-existent file - $FILENAME"
            exit 1
        fi
        
        rm "$FILENAME"
        echo "✓ File '$FILENAME' deleted successfully"
        log_message "Deleted file: $FILENAME"
        ;;
    
    list)
        echo "=== Files in current directory ==="
        ls -lh
        log_message "Listed files in current directory"
        ;;
    
    rename)
        if [[ $# -lt 3 ]]; then
            echo "Error: rename requires old filename and new filename"
            exit 1
        fi
        OLD_NAME="$2"
        NEW_NAME="$3"
        
        if [[ ! -e "$OLD_NAME" ]]; then
            echo "Error: File '$OLD_NAME' does not exist"
            log_message "Error: Attempted to rename non-existent file - $OLD_NAME"
            exit 1
        fi
        
        if [[ -e "$NEW_NAME" ]]; then
            echo "Error: File '$NEW_NAME' already exists"
            log_message "Error: Attempted to rename to existing file - $NEW_NAME"
            exit 1
        fi
        
        mv "$OLD_NAME" "$NEW_NAME"
        echo "✓ File '$OLD_NAME' renamed to '$NEW_NAME' successfully"
        log_message "Renamed file: $OLD_NAME -> $NEW_NAME"
        ;;
esac

log_message "Command executed: $COMMAND"
