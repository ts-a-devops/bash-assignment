#!/bin/bash

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/file_manager.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

ACTION=$1
TARGET=$2
NEW_NAME=$3

log_action() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

case "$ACTION" in

    create)
        if [[ -z "$TARGET" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ -e "$TARGET" ]]; then
            echo "Error: File already exists. Cannot overwrite."
            log_action "FAILED CREATE: $TARGET already exists"
            exit 1
        fi

        touch "$TARGET"
        echo "File '$TARGET' created."
        log_action "CREATED: $TARGET"
        ;;

    delete)
        if [[ -z "$TARGET" ]]; then
            echo "Error: Please provide a filename."
            exit 1
        fi

        if [[ ! -e "$TARGET" ]]; then
            echo "Error: File does not exist."
            log_action "FAILED DELETE: $TARGET not found"
            exit 1
        fi

        rm "$TARGET"
        echo "File '$TARGET' deleted."
        log_action "DELETED: $TARGET"
        ;;

    list)
        echo "Files in current directory:"
        ls -lh
        log_action "LISTED directory contents"
        ;;

    rename)
        if [[ -z "$TARGET" || -z "$NEW_NAME" ]]; then
            echo "Error: Provide current filename and new filename."
            exit 1
        fi

        if [[ ! -e "$TARGET" ]]; then
            echo "Error: File does not exist."
            log_action "FAILED RENAME: $TARGET not found"
            exit 1
        fi

        if [[ -e "$NEW_NAME" ]]; then
            echo "Error: Target name already exists."
            log_action "FAILED RENAME: $NEW_NAME already exists"
            exit 1
        fi

        mv "$TARGET" "$NEW_NAME"
        echo "File renamed from '$TARGET' to '$NEW_NAME'."
        log_action "RENAMED: $TARGET to $NEW_NAME"
        ;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create <filename>"
        echo "./file_manager.sh delete <filename>"
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename <oldname> <newname>"
        ;;
esac
