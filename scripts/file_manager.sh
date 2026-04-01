#!/bin/bash
# scripts/file_manager.sh

# Ensure logs directory exists
mkdir -p logs

LOG_FILE="logs/file_manager.log"

# Function to log messages with timestamp
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check for at least 2 arguments for commands that need them
COMMAND=$1
TARGET=$2
TARGET2=$3

case "$COMMAND" in
    create)
        if [[ -z "$TARGET" ]]; then
            echo "Usage: $0 create <filename>"
            exit 1
        fi
        if [[ -e "$TARGET" ]]; then
            echo "Error: $TARGET already exists. Not overwriting."
            log_action "CREATE FAILED: $TARGET already exists"
        else
            touch "$TARGET"
            echo "Created file $TARGET"
            log_action "CREATE: $TARGET"
        fi
        ;;
    delete)
        if [[ -z "$TARGET" ]]; then
            echo "Usage: $0 delete <filename>"
            exit 1
        fi
        if [[ -e "$TARGET" ]]; then
            rm "$TARGET"
            echo "Deleted file $TARGET"
            log_action "DELETE: $TARGET"
        else
            echo "Error: $TARGET does not exist."
            log_action "DELETE FAILED: $TARGET does not exist"
        fi
        ;;
    list)
        echo "Files in current directory:"
        ls -1
        log_action "LIST: current directory"
        ;;
    rename)
        if [[ -z "$TARGET" || -z "$TARGET2" ]]; then
            echo "Usage: $0 rename <oldname> <newname>"
            exit 1
        fi
        if [[ ! -e "$TARGET" ]]; then
            echo "Error: $TARGET does not exist."
            log_action "RENAME FAILED: $TARGET does not exist"
        elif [[ -e "$TARGET2" ]]; then
            echo "Error: $TARGET2 already exists. Cannot overwrite."
            log_action "RENAME FAILED: $TARGET2 already exists"
        else
            mv "$TARGET" "$TARGET2"
            echo "Renamed $TARGET to $TARGET2"
            log_action "RENAME: $TARGET -> $TARGET2"
        fi
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} [args...]"
        exit 1
        ;;
esac
