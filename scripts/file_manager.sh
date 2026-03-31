#!/usr/bin/env bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

log_action() {
  echo "$(date '+%F %T') - $1" >> "$LOG_FILE"
}

usage() {
  echo "Usage:"
  echo "  $0 create <filename>"
  echo "  $0 delete <filename>"
  echo "  $0 list"
  echo "  $0 rename <oldname> <newname>"
}

command="$1"

case "$command" in
  create)
    file="$2"
    if [[ -z "$file" ]]; then
      echo "Error: filename required."
      usage
      exit 1
    fi
    if [[ -e "$file" ]]; then
      echo "Error: $file already exists."
      log_action "FAILED create $file (already exists)"
      exit 1
    fi
    touch "$file"
    echo "Created $file"
    log_action "Created $file"
    ;;
  delete)
    file="$2"
    if [[ -z "$file" ]]; then
      echo "Error: filename required."
      usage
      exit 1
    fi
    if [[ ! -e "$file" ]]; then
      echo "Error: $file does not exist."
      log_action "FAILED delete $file (not found)"
      exit 1
    fi
    rm -f "$file"
    echo "Deleted $file"
    log_action "Deleted $file"
    ;;
  list)
    ls -lah
    log_action "Listed files"
    ;;
  rename)
    oldname="$2"
    newname="$3"
    if [[ -z "$oldname" || -z "$newname" ]]; then
      echo "Error: old and new filenames required."
      usage
      exit 1
    fi
    if [[ ! -e "$oldname" ]]; then
      echo "Error: $oldname does not exist."
      log_action "FAILED rename $oldname to $newname (source missing)"
      exit 1
    fi
    if [[ -e "$newname" ]]; then
      echo "Error: $newname already exists."
      log_action "FAILED rename $oldname to $newname (target exists)"
      exit 1
    fi
    mv "$oldname" "$newname"
    echo "Renamed $oldname to $newname"
    log_action "Renamed $oldname to $newname"
    ;;
  *)
    usage
    exit 1
    ;;
esac
