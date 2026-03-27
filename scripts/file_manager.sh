#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "$LOG_FILE"
}

usage() {
  printf 'Usage:\n'
  printf '  %s create <file>\n' "$(basename "$0")"
  printf '  %s delete <file>\n' "$(basename "$0")"
  printf '  %s list [directory]\n' "$(basename "$0")"
  printf '  %s rename <source> <target>\n' "$(basename "$0")"
}

command="${1:-}"

if [[ -z "$command" ]]; then
  usage
  exit 1
fi

case "$command" in
  create)
    file="${2:-}"
    if [[ -z "$file" ]]; then
      printf 'Error: file name is required for create.\n'
      exit 1
    fi
    if [[ -e "$file" ]]; then
      printf 'Error: %s already exists. Overwrite prevented.\n' "$file"
      log_message "CREATE_FAILED $file already exists"
      exit 1
    fi
    : > "$file"
    printf 'Created %s\n' "$file"
    log_message "CREATED $file"
    ;;
  delete)
    file="${2:-}"
    if [[ -z "$file" ]]; then
      printf 'Error: file name is required for delete.\n'
      exit 1
    fi
    if [[ ! -e "$file" ]]; then
      printf 'Error: %s does not exist.\n' "$file"
      log_message "DELETE_FAILED $file not found"
      exit 1
    fi
    rm -f -- "$file"
    printf 'Deleted %s\n' "$file"
    log_message "DELETED $file"
    ;;
  list)
    target="${2:-.}"
    if [[ ! -d "$target" ]]; then
      printf 'Error: %s is not a directory.\n' "$target"
      log_message "LIST_FAILED $target not a directory"
      exit 1
    fi
    ls -la -- "$target"
    log_message "LISTED $target"
    ;;
  rename)
    source_file="${2:-}"
    target_file="${3:-}"
    if [[ -z "$source_file" || -z "$target_file" ]]; then
      printf 'Error: source and target are required for rename.\n'
      exit 1
    fi
    if [[ ! -e "$source_file" ]]; then
      printf 'Error: %s does not exist.\n' "$source_file"
      log_message "RENAME_FAILED $source_file not found"
      exit 1
    fi
    if [[ -e "$target_file" ]]; then
      printf 'Error: %s already exists. Overwrite prevented.\n' "$target_file"
      log_message "RENAME_FAILED target $target_file already exists"
      exit 1
    fi
    mv -- "$source_file" "$target_file"
    printf 'Renamed %s to %s\n' "$source_file" "$target_file"
    log_message "RENAMED $source_file to $target_file"
    ;;
  *)
    printf 'Error: unsupported command %s\n' "$command"
    usage
    exit 1
    ;;
esac
