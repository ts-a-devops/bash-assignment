#!/bin/bash

LOG_FILE="logs/file_manager.log"

mkdir -p logs

log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

ACTION=$1
TARGET=$2
NEW_NAME=$3

if [ -z "$ACTION" ]; then
    echo "Usage: create|delete|list|rename"
    exit 1
fi

case "$ACTION" in

create)
    if [ -z "$TARGET" ]; then
        echo "Please provide a filename"
        exit 1
    fi

    if [ -f "$TARGET" ]; then
        echo "File already exists: $TARGET"
        log_action "Failed to create $TARGET (already exists)"
    else
        touch "$TARGET"
        echo "File created: $TARGET"
        log_action "Created file $TARGET"
    fi
    ;;

delete)
    if [ -z "$TARGET" ]; then
        echo "Please provide a filename"
        exit 1
    fi

    if [ -f "$TARGET" ]; then
        rm "$TARGET"
        echo "File deleted: $TARGET"
        log_action "Deleted file $TARGET"
    else
        echo "File not found: $TARGET"
        log_action "Failed to delete $TARGET (not found)"
    fi
    ;;

list)
    echo "Listing files..."
    ls -lah
    log_action "Listed files in directory"
    ;;

rename)
    if [ -z "$TARGET" ] || [ -z "$NEW_NAME" ]; then
        echo "Usage: rename old_name new_name"
        exit 1
    fi

    if [ -f "$TARGET" ]; then
        mv "$TARGET" "$NEW_NAME"
        echo "Renamed $TARGET to $NEW_NAME"
        log_action "Renamed $TARGET to $NEW_NAME"
    else
        echo "File not found: $TARGET"
        log_action "Failed rename $TARGET (not found)"
    fi
    ;;

*)
    echo "Invalid action"
    echo "Usage: ./file_manager.sh create|delete|list|rename"
    ;;
esac
