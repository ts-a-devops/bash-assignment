#!/bin/bash

mkdir -p logs
LOGFILE="logs/file_manager.log"

ACTION=$1
FILENAME=$2

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

case $ACTION in
    create)
        if [ -f "$FILENAME" ]; then
            log "ERROR: '$FILENAME' already exists. Overwrite prevented."
        else
            touch "$FILENAME"
            log "Created file: $FILENAME"
        fi
        ;;
    delete)
        if [ ! -f "$FILENAME" ]; then
            log "ERROR: '$FILENAME' does not exist."
        else
            rm "$FILENAME"
            log "Deleted file: $FILENAME"
        fi
        ;;
    list)
        log "Listing files in current directory"
        ls -la
        ;;
    rename)
        NEWNAME=$3
        if [ ! -f "$FILENAME" ]; then
            log "ERROR: '$FILENAME' does not exist."
        else
            mv "$FILENAME" "$NEWNAME"
            log "Renamed '$FILENAME' to '$NEWNAME'"
        fi
        ;;
    *)
        echo "Usage: ./file_manager.sh [create|delete|list|rename] [filename]"
        ;;
esac
