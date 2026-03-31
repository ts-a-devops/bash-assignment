#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"

log_action() {
  local message="$1"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

usage() {
  echo "Usage:"
  echo "  ./file_manager.sh create <filename>"
  echo "  ./file_manager.sh delete <filename>"
  echo "  ./file_manager.sh list <directory>"
  echo "  ./file_manager.sh rename <old_name> <new_name>"
  exit 1
}

if [[ $# -lt 2 ]]; then
  usage
fi

command="$1"
target="$2"

case "$command" in

  create)
    if [[ -e "$target" ]]; then
      echo "❌ Error: '$target' already exists. Overwriting is not allowed."
      log_action "FAILED create - '$target' already exists."
      exit 1
    fi
    touch "$target"
    log_action "CREATED '$target'"
    echo "✅ File '$target' created successfully."
    ;;

  delete)
    if [[ ! -e "$target" ]]; then
      echo "❌ Error: '$target' does not exist."
      log_action "FAILED delete - '$target' not found."
      exit 1
    fi
    rm -rf "$target"
    log_action "DELETED '$target'"
    echo "✅ '$target' deleted successfully."
    ;;

  list)
    if [[ ! -d "$target" ]]; then
      echo "❌ Error: '$target' is not a valid directory."
      log_action "FAILED list - '$target' is not a directory."
      exit 1
    fi
    echo "📂 Contents of '$target':"
    ls -lh "$target"
    log_action "LISTED contents of '$target'"
    ;;

  rename)
    if [[ $# -lt 3 ]]; then
      echo "❌ Error: rename requires two arguments: <old_name> <new_name>"
      exit 1
    fi
    new_name="$3"
    if [[ ! -e "$target" ]]; then
      echo "❌ Error: '$target' does not exist."
      log_action "FAILED rename - '$target' not found."
      exit 1
    fi
    if [[ -e "$new_name" ]]; then
      echo "❌ Error: '$new_name' already exists. Overwriting is not allowed."
      log_action "FAILED rename - '$new_name' already exists."
      exit 1
    fi
    mv "$target" "$new_name"
    log_action "RENAMED '$target' to '$new_name'"
    echo "✅ Renamed '$target' to '$new_name'."
    ;;

  *)
    echo "❌ Unknown command: '$command'"
    usage
    ;;

esac

