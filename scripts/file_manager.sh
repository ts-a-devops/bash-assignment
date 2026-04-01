#!/bin/bash

mkdir -p logs
LOGFILE="logs/file_manager.log"
ACTION=$1
FILENAME=$2

log() {
  echo "$1"
  echo "$(date): $1" >> $LOGFILE
}

case $ACTION in
  create)
    if [ -z "$FILENAME" ]; then
      log "Error: Please provide a filename"
      exit 1
    fi
    if [ -f "$FILENAME" ]; then
      log "Error: File '$FILENAME' already exists!"
    else
      touch "$FILENAME"
      log "Created file: $FILENAME"
    fi
    ;;
  delete)
    if [ -f "$FILENAME" ]; then
      rm "$FILENAME"
      log "Deleted file: $FILENAME"
    else
      log "Error: File '$FILENAME' not found!"
    fi
    ;;
  list)
    log "Listing files in current directory:"
    ls -lh
    ;;
  rename)
    NEWNAME=$3
    if [ -f "$FILENAME" ]; then
      mv "$FILENAME" "$NEWNAME"
      log "Renamed '$FILENAME' to '$NEWNAME'"
    else
      log "Error: File '$FILENAME' not found!"
    fi
    ;;
  *)
    echo "Usage: ./file_manager.sh [create|delete|list|rename] [filename]"
    ;;
esac
