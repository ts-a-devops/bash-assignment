#!/usr/bin/env bash

LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

action=$1
file1=$2
file2=$3

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

case "$action" in
    create)
        if [[ -f "$file1" ]]; then
            echo "File already exists."
        else
            touch "$file1"
            echo "File created."
            log "Created $file1"
        fi
        ;;
    delete)
        if [[ -f "$file1" ]]; then
            rm "$file1"
            echo "File deleted."
            log "Deleted $file1"
        else
            echo "File not found."
        fi
        ;;
    list)
        ls -lh
        log "Listed files"
        ;;
    rename)
        if [[ -f "$file1" ]]; then
            mv "$file1" "$file2"
            echo "File renamed."
            log "Renamed $file1 to $file2"
        else
            echo "File not found."
        fi
        ;;
    *)
        echo "Usage: $0 {create|delete|list|rename} filename [newname]"
        ;;
esac
