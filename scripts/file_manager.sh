#!/usr/bin/env bash
mkdir -p logs
LOG_FILE="logs/file_manager.log"

usage() {
  echo "Usage:"
  echo "  $0 create <filename>"
  echo "  $0 delete <filename>"
  echo "  $0 list"
  echo "  $0 rename <oldname> <newname>"
}

log_action() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

command="$1"

case "$command" in
  create)
    if [[ $# -ne 2 ]]; then
      usage
      exit 1
    fi

    file="$2"

    if [[ -e "$file" ]]; then
      echo "Error: '$file' already exists. Will not overwrite."
      log_action "CREATE FAILED: '$file' already exists."
      exit 1
    fi

    touch "$file"
    echo "File '$file' created successfully."
    log_action "CREATED: '$file'"
    ;;

  delete)
    if [[ $# -ne 2 ]]; then
      usage
      exit 1
    fi

    file="$2"

    if [[ ! -e "$file" ]]; then
      echo "Error: '$file' does not exist."
      log_action "DELETE FAILED: '$file' does not exist."
      exit 1
    fi

    rm -f "$file"
    echo "File '$file' deleted successfully."
    log_action "DELETED: '$file'"
    ;;

  list)
    ls -lah
    log_action "LIST executed."
    ;;

  rename)
    if [[ $# -ne 3 ]]; then
      usage
      exit 1
    fi

    oldname="$2"
    newname="$3"

    if [[ ! -e "$oldname" ]]; then
      echo "Error: '$oldname' does not exist."
      log_action "RENAME FAILED: '$oldname' does not exist."
      exit 1
    fi

    if [[ -e "$newname" ]]; then
      echo "Error: '$newname' already exists. Will not overwrite."
      log_action "RENAME FAILED: '$newname' already exists."
      exit 1
    fi

    mv "$oldname" "$newname"
    echo "Renamed '$oldname' to '$newname'."
    log_action "RENAMED: '$oldname' -> '$newname'"
    ;;

  *)
    usage
    exit 1
    ;;
esac


