#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"

ACTION=${1:-}
FILE=${2:-}
NEW_NAME=${3:-}

case "$ACTION" in
  create)
    [[ -z "$FILE" ]] && echo "Usage: create <file>" && exit 1
    [[ -e "$FILE" ]] && echo "File exists" && exit 1
    touch "$FILE"
    echo "$(date): Created $FILE" >> "$LOG_FILE"
    ;;

  delete)
    [[ ! -e "$FILE" ]] && echo "Not found" && exit 1
    rm "$FILE"
    echo "$(date): Deleted $FILE" >> "$LOG_FILE"
    ;;

  list)
    ls -lh
    ;;

  rename)
    [[ ! -e "$FILE" || -z "$NEW_NAME" ]] && echo "Usage: rename old new" && exit 1
    mv "$FILE" "$NEW_NAME"
    echo "$(date): Renamed $FILE" >> "$LOG_FILE"
    ;;

  *)
    echo "Usage: create|delete|list|rename"
    ;;
esac
