#!/bin/bash
# file_manager.sh - Simple file operations with logging

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <create|delete|list|rename> <filename> [newname]" >&2
    exit 1
fi

ACTION=$1
FILE=$2
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/file_manager.log"
mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

case "$ACTION" in
    create)
        if [[ -e "$FILE" ]]; then
            echo "Error: File '$FILE' already exists. Not overwriting."
            exit 1
        fi
        touch "$FILE"
        echo "Created file: $FILE"
        log_action "Created file: $FILE"
        ;;
    delete)
        if [[ ! -f "$FILE" ]]; then
            echo "Error: File '$FILE' does not exist."
            exit 1
        fi
        rm "$FILE"
        echo "Deleted file: $FILE"
        log_action "Deleted file: $FILE"
        ;;
    list)
        echo "Files in current directory:"
        ls -la
        log_action "Listed files"
        ;;
    rename)
        if [[ $# -ne 3 ]]; then
            echo "Usage for rename: $0 rename <oldname> <newname>" >&2
            exit 1
        fi
        NEWNAME=$3
        if [[ ! -f "$FILE" ]]; then
            echo "Error: File '$FILE' does not exist."
            exit 1
        fi
        if [[ -e "$NEWNAME" ]]; then
            echo "Error: '$NEWNAME' already exists."
            exit 1
        fi
        mv "$FILE" "$NEWNAME"
        echo "Renamed '$FILE' to '$NEWNAME'"
        log_action "Renamed '$FILE' to '$NEWNAME'"
        ;;
    *)
        echo "Unknown action: $ACTION" >&2
        echo "Supported: create, delete, list, rename" >&2
        exit 1
        ;;
esac
