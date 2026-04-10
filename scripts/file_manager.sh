#!/usr/bin/env bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log_action() {
  echo "[$(timestamp)] $1" >> "$LOG_FILE"
}

usage() {
  echo "Usage: $0 {create|delete|list|rename} [args]"
  echo "Examples:"
  echo "  $0 create file.txt"
  echo "  $0 delete file.txt"
  echo "  $0 list ."
  echo "  $0 rename old.txt new.txt"
}

command="$1"

case "$command" in
  create)
    file="$2"
    if [[ -z "$file" ]]; then
      echo "Error: Please provide a filename to create."
      usage
      exit 1
    fi

    if [[ -e "$file" ]]; then
      msg="Create failed: '$file' already exists."
      echo "$msg"
      log_action "$msg"
      exit 1
    fi

    touch "$file"
    msg="Created file: '$file'"
    echo "$msg"
    log_action "$msg"
    ;;

  delete)
    file="$2"
    if [[ -z "$file" ]]; then
      echo "Error: Please provide a filename to delete."
      usage
      exit 1
    fi

    if [[ ! -e "$file" ]]; then
      msg="Delete failed: '$file' does not exist."
      echo "$msg"
      log_action "$msg"
      exit 1
    fi

    rm -f "$file"
    msg="Deleted: '$file'"
    echo "$msg"
    log_action "$msg"
    ;;

  list)
    target="${2:-.}"
    if [[ ! -d "$target" ]]; then
      msg="List failed: '$target' is not a directory."
      echo "$msg"
      log_action "$msg"
      exit 1
    fi

    echo "Listing files in '$target':"
    ls -la "$target"
    log_action "Listed directory: '$target'"
    ;;

  rename)
    old_name="$2"
    new_name="$3"

    if [[ -z "$old_name" || -z "$new_name" ]]; then
      echo "Error: Please provide source and destination names."
      usage
      exit 1
    fi

    if [[ ! -e "$old_name" ]]; then
      msg="Rename failed: '$old_name' does not exist."
      echo "$msg"
      log_action "$msg"
      exit 1
    fi

    if [[ -e "$new_name" ]]; then
      msg="Rename failed: '$new_name' already exists."
      echo "$msg"
      log_action "$msg"
      exit 1
    fi

    mv "$old_name" "$new_name"
    msg="Renamed '$old_name' to '$new_name'"
    echo "$msg"
    log_action "$msg"
    ;;

  *)
    echo "Error: Invalid command."
    usage
    exit 1
    ;;
esac
