#!/bin/bash
set -euo pipefail

LOGFILE="logs/file_manager.log"
ACTION=${1:-""}

log() {
    echo "$(date) - $1" >> "$LOGFILE"
}

case "$ACTION" in

    create)
        FILE=$2
        if [[ -e "$FILE" ]]; then
            echo "File already exists!"
            log "Failed to create: $FILE already exists"
        else
            touch "$FILE"
            echo "File created: $FILE"
            log "Created file: $FILE"
        fi
        ;;

    delete)
        FILE=$2
        if [[ -e "$FILE" ]]; then
            rm "$FILE"
            echo "File deleted: $FILE"
            log "Deleted file: $FILE"
        else
            echo "File not found!"
            log "Delete failed: $FILE not found"
        fi
        ;;

    list)
        ls -l
        log "Listed files"
        ;;

    rename)
        OLD=$2
        NEW=$3
        if [[ ! -e "$OLD" ]]; then
            echo "Original file not found!"
            log "Rename failed: $OLD not found"
        else
            mv "$OLD" "$NEW"
            echo "Renamed to $NEW"
            log "Renamed $OLD to $NEW"
        fi
        ;;

    *)
        echo "Usage: ./file_manager.sh {create|delete|list|rename} filename"
        exit 1
        ;;
esac