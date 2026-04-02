#!/bin/bash

LOG_FILE="../logs/file_manager.log"
mkdir -p "$(dirname "$LOG_FILE")"

ACTION=$1
FILE=$2
NEW_NAME=$3

# Logging function
log() {
  echo -e "$1" | tee -a "$LOG_FILE"
}

# Validate action
if [[ -z "$ACTION" ]]; then
  log "Error: No action provided"
  log "Usage: $0 {create|delete|list|rename} filename [new_name]"
  exit 1
fi

case "$ACTION" in
  create)
    if [[ -z "$FILE" ]]; then
      log "Please provide a filename"
    elif [[ -f "$FILE" ]]; then
      log "File already exists: $FILE"
    else
      touch "$FILE"
      log "File created: $FILE"
    fi
    ;;

  delete)
    if [[ -z "$FILE" ]]; then
      log "Please provide a filename"
    elif [[ -f "$FILE" ]]; then
      read -p "Are you sure you want to delete '$FILE'? (y/n): " confirm
      if [[ "$confirm" == "y" ]]; then
        rm "$FILE"
        log "File deleted: $FILE"
      else
        log "Deletion cancelled"
      fi
    else
      log "File not found: $FILE"
    fi
    ;;

  list)
    log "File list:"
    ls -lh | tee -a "$LOG_FILE"
    ;;

  rename)
    if [[ -z "$FILE" || -z "$NEW_NAME" ]]; then
      log "Usage: rename <old_name> <new_name>"
    elif [[ -f "$FILE" ]]; then
      mv "$FILE" "$NEW_NAME"
      log "Renamed $FILE → $NEW_NAME"
    else
      log "File not found: $FILE"
    fi
    ;;

  *)
    log "Invalid action"
    log "Usage: $0 {create|delete|list|rename} filename [new_name]"
    ;;
esac
