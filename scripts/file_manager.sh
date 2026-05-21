#!/bin/bash

# Create log directory
mkdir -p logs

ACTION=$1
FILENAME=$2

if [[ -z "$ACTION" ]]; then
    echo "Usage: $0 <create|delete|list|rename> [filename] [newname]"
    exit 1
fi

if [[ "$ACTION" != "list" && -z "$FILENAME" ]]; then
    echo "Error: Filename required for action '$ACTION'"
    echo "Usage: $0 $ACTION <filename> [newname]"
    exit 1
fi

LOGFILE="logs/file_manager.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

case "$ACTION" in
    create)
        if [[ -e "$FILENAME" ]]; then
            echo "Error: File '$FILENAME' already exists. Not overwriting."
        else
            touch "$FILENAME" && echo "File '$FILENAME' created successfully."
            log_action "Created file: $FILENAME"
        fi
        ;;
    delete)
        if [[ -e "$FILENAME" ]]; then
            rm "$FILENAME" && echo "File '$FILENAME' deleted."
            log_action "Deleted file: $FILENAME"
        else
            echo "Error: File '$FILENAME' does not exist."
        fi
        ;;
    list)
        ls -la
        log_action "Listed files"
        ;;
    rename)
        NEWNAME=$3
        if [[ -z "$NEWNAME" ]]; then
            echo "Usage: $0 rename <oldname> <newname>"
            exit 1
        fi
        if [[ -e "$FILENAME" ]]; then
            mv "$FILENAME" "$NEWNAME" && echo "Renamed '$FILENAME' to '$NEWNAME'."
            log_action "Renamed $FILENAME to $NEWNAME"
        else
            echo "Error: File '$FILENAME' does not exist."
        fi
        ;;
    *)
        echo "Invalid action. Use: create, delete, list, rename"
        ;;
esac