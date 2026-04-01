#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

usage() {
  echo "Usage:"
  echo "  $0 create <file>"
  echo "  $0 delete <file>"
  echo "  $0 list [directory]"
  echo "  $0 rename <old_name> <new_name>"
  exit 1
}

[[ $# -ge 1 ]] || usage

command="$1"

case "$command" in
  create)
    [[ $# -eq 2 ]] || usage
    file="$2"

    if [[ -e "$file" ]]; then
      echo "Error: '$file' already exists. Overwriting is not allowed."
      log "ERROR - CREATE failed for '$file' (already exists)"
      exit 1
    fi

    mkdir -p "$(dirname "$file")"
    touch "$file"
    echo "Created: $file"
    log "CREATE - '$file'"
    ;;

  delete)
    [[ $# -eq 2 ]] || usage
    file="$2"

    if [[ ! -e "$file" ]]; then
      echo "Error: '$file' does not exist."
      log "ERROR - DELETE failed for '$file' (not found)"
      exit 1
    fi

    rm -f -- "$file"
    echo "Deleted: $file"
    log "DELETE - '$file'"
    ;;

  list)
    target="${2:-.}"

    if [[ ! -d "$target" ]]; then
      echo "Error: '$target' is not a directory."
      log "ERROR - LIST failed for '$target' (not a directory)"
      exit 1
    fi

    ls -lah "$target"
    log "LIST - '$target'"
    ;;

  rename)
    [[ $# -eq 3 ]] || usage
    old_name="$2"
    new_name="$3"

    if [[ ! -e "$old_name" ]]; then
      echo "Error: '$old_name' does not exist."
      log "ERROR - RENAME failed. Source '$old_name' not found"
      exit 1
    fi

    if [[ -e "$new_name" ]]; then
      echo "Error: '$new_name' already exists. Overwriting is not allowed."
      log "ERROR - RENAME failed. Target '$new_name' already exists"
      exit 1
    fi

    mv -- "$old_name" "$new_name"
    echo "Renamed: $old_name -> $new_name"
    log "RENAME - '$old_name' -> '$new_name'"
    ;;

  *)
    usage
    ;;
esac

