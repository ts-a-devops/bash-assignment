#!/usr/bin/env bash

# Setup logging
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"

log_action() {
    local message="$1"
    echo "$message"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

ACTION="$1"
TARGET="$2"
NEW_TARGET="$3"

case "$ACTION" in
    create)
        if [ -z "$TARGET" ]; then
            echo "Error: Please specify a filename to create."
            echo "Usage: $0 create <filename>"
            exit 1
        fi
        if [ -e "$TARGET" ]; then
            log_action "Error: File '$TARGET' already exists. Overwrite prevented."
            exit 1
        else
            touch "$TARGET"
            log_action "Success: Created file '$TARGET'."
        fi
        ;;

    delete)
        if [ -z "$TARGET" ]; then
            echo "Error: Please specify a filename to delete."
            echo "Usage: $0 delete <filename>"
            exit 1
        fi
        if [ ! -e "$TARGET" ]; then
            log_action "Error: File '$TARGET' does not exist."
            exit 1
        else
            rm "$TARGET"
            log_action "Success: Deleted file '$TARGET'."
        fi
        ;;

    list)
        log_action "Action: Listed directory contents."
        echo "----------------------------------------"
        ls -la
        echo "----------------------------------------"
        ;;

    rename)
        if [[ -z "$TARGET" || -z "$NEW_TARGET" ]]; then
            echo "Error: Please specify both current and new filenames."
            echo "Usage: $0 rename <old_name> <new_name>"
            exit 1
        fi
        if [ ! -e "$TARGET" ]; then
            log_action "Error: Source file '$TARGET' does not exist."
            exit 1
        fi
        if [ -e "$NEW_TARGET" ]; then
            log_action "Error: Destination '$NEW_TARGET' already exists. Overwrite prevented."
            exit 1
        fi
        mv "$TARGET" "$NEW_TARGET"
        log_action "Success: Renamed '$TARGET' to '$NEW_TARGET'."
        ;;

    *)
        echo "Usage: $0 {create <file>|delete <file>|list|rename <old> <new>}"
        exit 1
        ;;
esac
