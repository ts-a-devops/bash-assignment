#!/usr/bin/env bash
# file_manager.sh - Simple file operations manager
# Usage: ./file_manager.sh <command> [args]
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

COMMANDS="create | delete | list | rename"

log() {
  local level=$1; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}
usage() {
  echo "Usage: $0 <command> [args]"
  echo "Commands: $COMMANDS"
  echo
  echo "  $0 create <file>"
  echo "  $0 delete <file>"
  echo "  $0 list   [directory]"
  echo "  $0 rename <old> <new>"
  exit 1
}

cmd_create() {
  local target="${1:-}"
  [[ -z "$target" ]] && { echo "  Usage: $0 create <file>"; exit 1; }

  if [[ -e "$target" ]]; then
    log "WARN" "Create skipped — '$target' already exists."
    echo "  '$target' already exists. Will not overwrite."
    exit 1
  fi

  touch "$target"
  log "INFO" "Created file: $target"
  echo "  Created: $target"
}

cmd_delete() {
  local target="${1:-}"
  [[ -z "$target" ]] && { echo "  Usage: $0 delete <file>"; exit 1; }

  if [[ ! -e "$target" ]]; then
    log "WARN" "Delete skipped — '$target' not found."
    echo "  '$target' does not exist."
    exit 1
  fi

  rm -rf "$target"
  log "INFO" "Deleted: $target"
  echo "  Deleted: $target"
}

cmd_list() {
  local dir="${1:-.}"

  if [[ ! -d "$dir" ]]; then
    log "WARN" "List skipped — '$dir' is not a directory."
    echo "  '$dir' is not a valid directory."
    exit 1
  fi

  log "INFO" "Listed directory: $dir"
  echo "  Contents of '$dir':"
  ls -lAh --color=auto "$dir"
}

cmd_rename() {
  local old="${1:-}" new="${2:-}"
  [[ -z "$old" || -z "$new" ]] && { echo "  Usage: $0 rename <old> <new>"; exit 1; }

  if [[ ! -e "$old" ]]; then
    log "WARN" "Rename skipped — '$old' not found."
    echo "  '$old' does not exist."
    exit 1
  fi

  if [[ -e "$new" ]]; then
    log "WARN" "Rename skipped — '$new' already exists."
    echo "  '$new' already exists. Will not overwrite."
    exit 1
  fi

  mv "$old" "$new"
  log "INFO" "Renamed: $old → $new"
  echo "  Renamed: $old → $new"
}


COMMAND="${1:-}"
shift 2>/dev/null || true

case "$COMMAND" in
  create) cmd_create "$@" ;;
  delete) cmd_delete "$@" ;;
  list)   cmd_list   "$@" ;;
  rename) cmd_rename "$@" ;;
  ""|--help|-h) usage ;;
  *)
    echo "  Unknown command: '$COMMAND'"
    echo "Valid commands: $COMMANDS"
    log "ERROR" "Unknown command: $COMMAND"
    exit 1
    ;;
esac
