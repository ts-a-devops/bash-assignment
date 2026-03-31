#!/bin/bash

#Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define directories
BASE_DIR="$SCRIPT_DIR/.."
TARGET_DIR="$BASE_DIR/logs/files_created"
LOG_FILE="$BASE_DIR/logs/file_manager.log"

# Ensure directories exist
mkdir -p "$TARGET_DIR"
mkdir -p "$BASE_DIR/logs"

ACTION=$1
shift   # removes ACTION, so remaining args = files

log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

case "$ACTION" in

    create)
        if [[ $# -eq 0 ]]; then
            echo "Error: No filenames provided."
            exit 1
        fi

        for FILE in "$@"; do
            FULL_PATH="$TARGET_DIR/$FILE"

            if [[ -e "$FULL_PATH" ]]; then
                echo "Skipping '$FILE' (already exists)"
                continue
            fi

            touch "$FULL_PATH"
            echo "Created '$FILE'"
            log_action "Created file $FILE"
        done
        ;;

    delete)
        if [[ $# -eq 0 ]]; then
            echo "Error: No filenames provided."
            exit 1
        fi

        for FILE in "$@"; do
            FULL_PATH="$TARGET_DIR/$FILE"

            if [[ ! -e "$FULL_PATH" ]]; then
                echo "Skipping '$FILE' (not found)"
                continue
            fi

            rm "$FULL_PATH"
            echo "Deleted '$FILE'"
            log_action "Deleted file $FILE"
        done
        ;;

    list)
        echo "Files in $TARGET_DIR:"
        ls -lh "$TARGET_DIR"
        log_action "Listed files"
        ;;

    rename)
        if [[ $# -ne 2 ]]; then
            echo "Error: Provide exactly 2 arguments (oldname newname)."
            exit 1
        fi

        OLD_PATH="$TARGET_DIR/$1"
        NEW_PATH="$TARGET_DIR/$2"

        if [[ ! -e "$OLD_PATH" ]]; then
            echo "Error: Source file does not exist."
            exit 1
        fi

        if [[ -e "$NEW_PATH" ]]; then
            echo "Error: Target file already exists."
            exit 1
        fi

        mv "$OLD_PATH" "$NEW_PATH"
        echo "Renamed '$1' to '$2'"
        log_action "Renamed $1 to $2"
        ;;

    *)
        echo "Usage:"
        echo "./file_manager.sh create <file1> <file2> ..."
        echo "./file_manager.sh delete <file1> <file2> ..."
        echo "./file_manager.sh list"
        echo "./file_manager.sh rename <oldname> <newname>"
        exit 1
        ;;

esac

