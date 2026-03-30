#!/bin/bash

LOG_FILE="../logs/file_manager.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

ACTION=$1
FILE=$2
NEW_NAME=$3

case "$ACTION" in
  create)
    if [[ -z "$FILE" ]]; then
      log "Error: No file name provided"
      exit 1
    fi

    if [[ -e "$FILE" ]]; then
      log "File already exists: $FILE"
    else
      touch "$FILE"
      log "File created: $FILE"
    fi
    ;;

  delete)
    if [[ -z "$FILE" ]]; then
      log "Error: No file name provided"
      exit 1
    fi

    if [[ -f "$FILE" ]]; then
      rm "$FILE"
      log "File deleted: $FILE"
    else
      log "File not found: $FILE"
    fi
    ;;

  list)
    log "Listing files in current directory:"
    ls -lh | tee -a "$LOG_FILE"
    ;;

  rename)
    if [[ -z "$FILE" || -z "$NEW_NAME" ]]; then
      log "Error: Provide current and new file name"
      exit 1
    fi

    if [[ -f "$FILE" ]]; then
      mv "$FILE" "$NEW_NAME"
      log "Renamed $FILE to $NEW_NAME"
    else
      log "File not found: $FILE"
    fi
    ;;

  *)
    log "Usage: $0 {create|delete|list|rename} <filename> [new_name]"
    exit 1
    ;;
esac
