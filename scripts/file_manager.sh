#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs
LOG_FILE="logs/file_manager.log"

action="${1:-}"

log() {
  echo "$(date '+%F %T') - $1" >> "$LOG_FILE"
}

case "$action" in
  create)
    filename="${2:-}"

    if [[ -z "$filename" ]]; then
      echo "Usage: $0 create <filename>"
      exit 1
    fi

    if [[ -e "$filename" ]]; then
      echo "Error: File already exists."
      log "CREATE FAILED - $filename exists"
      exit 1
    fi

    touch "$filename"
    echo "Created $filename"
    log "CREATED - $filename"
    ;;

  delete)
    filename="${2:-}"

    if [[ -z "$filename" ]]; then
      echo "Usage: $0 delete <filename>"
      exit 1
    fi

    if [[ ! -e "$filename" ]]; then
      echo "Error: File does not exist."
      log "DELETE FAILED - $filename not found"
      exit 1
    fi

    rm -f "$filename"
    echo "Deleted $filename"
    log "DELETED - $filename"
    ;;

  list)
    ls -lah
    log "LISTED files"
    ;;

  rename)
    oldname="${2:-}"
    newname="${3:-}"

    if [[ -z "$oldname" || -z "$newname" ]]; then
      echo "Usage: $0 rename <old> <new>"
      exit 1
    fi

    if [[ ! -e "$oldname" ]]; then
      echo "Error: File not found."
      log "RENAME FAILED - $oldname not found"
      exit 1
    fi

    if [[ -e "$newname" ]]; then
      echo "Error: Target file already exists."
      log "RENAME FAILED - $newname exists"
      exit 1
    fi

    mv "$oldname" "$newname"
    echo "Renamed $oldname to $newname"
    log "RENAMED - $oldname to $newname"
    ;;

  *)
    echo "Usage: $0 {create|delete|list|rename}"
    exit 1
    ;;
esac
