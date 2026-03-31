#!/bin/bash
set -euo pipefail

LOG_FILE="logs/file_manager.log"

ACTION=${1:-}
FILE=${2:-}

case "$ACTION" in
  create)
    if [[ -f "$FILE" ]]; then
      echo "File already exists."
    else
      touch "$FILE"
      echo "Created $FILE"
      echo "$(date): Created $FILE" >> "$LOG_FILE"
    fi
    ;;
  
  delete)
    if [[ -f "$FILE" ]]; then
      rm "$FILE"
      echo "Deleted $FILE"
      echo "$(date): Deleted $FILE" >> "$LOG_FILE"
    else
      echo "File not found."
    fi
    ;;
  
  list)
    ls -l
    ;;
  
  rename)
    NEW_NAME=${3:-}
    if [[ -f "$FILE" && -n "$NEW_NAME" ]]; then
      mv "$FILE" "$NEW_NAME"
      echo "Renamed $FILE to $NEW_NAME"
      echo "$(date): Renamed $FILE to $NEW_NAME" >> "$LOG_FILE"
    else
      echo "Invalid input."
    fi
    ;;
  
  *)
    echo "Usage: $0 {create|delete|list|rename} filename"
    ;;
esac
