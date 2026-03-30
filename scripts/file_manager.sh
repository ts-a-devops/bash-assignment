#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

log_action() {
  local status="$1"
  local action="$2"
  local detail="$3"
  printf "%s | %s | %s | %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$status" "$action" "$detail" >> "$LOG_FILE"
}

usage() {
  cat <<'EOF'
Usage:
  ./scripts/file_manager.sh create <file>
  ./scripts/file_manager.sh delete <file>
  ./scripts/file_manager.sh list [directory]
  ./scripts/file_manager.sh rename <old_name> <new_name>
EOF
}

if (( $# < 1 )); then
  usage
  exit 1
fi

command="$1"
shift || true

case "$command" in
  create)
    if (( $# != 1 )); then
      usage
      exit 1
    fi
    target="$1"
    if [[ -e "$target" ]]; then
      echo "Error: '$target' already exists."
      log_action "ERROR" "create" "target_exists:$target"
      exit 1
    fi
    touch "$target"
    echo "Created '$target'."
    log_action "OK" "create" "target:$target"
    ;;

  delete)
    if (( $# != 1 )); then
      usage
      exit 1
    fi
    target="$1"
    if [[ ! -e "$target" ]]; then
      echo "Error: '$target' does not exist."
      log_action "ERROR" "delete" "missing:$target"
      exit 1
    fi
    rm -rf -- "$target"
    echo "Deleted '$target'."
    log_action "OK" "delete" "target:$target"
    ;;

  list)
    if (( $# > 1 )); then
      usage
      exit 1
    fi
    dir="${1:-.}"
    if [[ ! -d "$dir" ]]; then
      echo "Error: '$dir' is not a directory."
      log_action "ERROR" "list" "invalid_directory:$dir"
      exit 1
    fi
    ls -la -- "$dir"
    log_action "OK" "list" "directory:$dir"
    ;;

  rename)
    if (( $# != 2 )); then
      usage
      exit 1
    fi
    old_name="$1"
    new_name="$2"

    if [[ ! -e "$old_name" ]]; then
      echo "Error: '$old_name' does not exist."
      log_action "ERROR" "rename" "missing_source:$old_name"
      exit 1
    fi

    if [[ -e "$new_name" ]]; then
      echo "Error: '$new_name' already exists."
      log_action "ERROR" "rename" "target_exists:$new_name"
      exit 1
    fi

    mv -- "$old_name" "$new_name"
    echo "Renamed '$old_name' to '$new_name'."
    log_action "OK" "rename" "from:$old_name,to:$new_name"
    ;;

  *)
    usage
    log_action "ERROR" "invalid_command" "command:$command"
    exit 1
    ;;
esac
