#!/bin/bash
set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$1] $2" | tee -a "$LOG_FILE"
}
# $1 = action label (e.g. CREATE) | $2 = message
# [$1] adds a label in brackets for easy log scanning

usage() {
  echo "Usage: $0 <create|delete|list|rename> [args]"
  echo "  $0 create <filename>"
  echo "  $0 delete <filename>"
  echo "  $0 list"
  echo "  $0 rename <old> <new>"
  exit 1
}
# $0: the script's own name | exit 1: stop with error

cmd="${1:-}"
# $1: first argument to the script | ${1:-}: use empty string if $1 is unset
# (needed because set -u would crash on an unset variable)

[[ -z "$cmd" ]] && usage
# If no command given, show usage. && means: run right side only if left is true.

case "$cmd" in
# case/esac: like a switch statement. Matches $cmd against each pattern.

  create)
    [[ -z "${2:-}" ]] && { echo "Error: filename required."; exit 1; }
    # { ...; }: group multiple commands after &&
    [[ -e "$2" ]] && { log "ERROR" "File '$2' already exists."; exit 1; }
    # -e: true if path EXISTS (file or directory) — prevents overwriting
    touch "$2"
    # touch: creates an empty file
    log "CREATE" "File '$2' created."
    ;;
    # ;;: ends a case branch (like break in other languages)

  delete)
    [[ -z "${2:-}" ]] && { echo "Error: filename required."; exit 1; }
    [[ ! -e "$2" ]] && { log "ERROR" "File '$2' not found."; exit 1; }
    # !: negation — "if it does NOT exist"
    rm "$2"
    log "DELETE" "File '$2' deleted."
    ;;

  list)
    log "LIST" "Listing files in current directory."
    ls -lh
    # ls -lh: long format (-l), human-readable sizes (-h)
    ;;

  rename)
    [[ -z "${2:-}" || -z "${3:-}" ]] && { echo "Error: old and new names required."; exit 1; }
    [[ ! -e "$2" ]] && { log "ERROR" "Source '$2' not found."; exit 1; }
    [[ -e "$3" ]] && { log "ERROR" "Destination '$3' already exists."; exit 1; }
    mv "$2" "$3"
    # mv: move/rename a file
    log "RENAME" "'$2' renamed to '$3'."
    ;;

  *)
    # *: catch-all — matches anything not matched above
    echo "Error: Unknown command '$cmd'."
    usage
    ;;
esac
