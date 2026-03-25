#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$COMMAND] $*" | tee -a "$LOG_FILE"
}

usage() {
    echo "Usage:"
    echo "  $(basename "$0") create <filename>"
    echo "  $(basename "$0") delete <filename>"
    echo "  $(basename "$0") list   [directory]"
    echo "  $(basename "$0") rename <old> <new>"
    exit 1
}

[[ $# -lt 1 ]] && { echo "No command provided."; usage; }

COMMAND="${1,,}"

case "$COMMAND" in
    create)
        [[ $# -lt 2 ]] && { echo "Usage: $(basename "$0") create <filename>"; exit 1; }
        [[ -e "$2" ]] && { echo "Error: '$2' already exists."; log "FAILED — '$2' already exists"; exit 1; }
        touch "$2"
        echo "Created: '$2'"
        log "Created — $2"
        ;;

    delete)
        [[ $# -lt 2 ]] && { echo "Usage: $(basename "$0") delete <filename>"; exit 1; }
        [[ ! -e "$2" ]] && { echo "Error: '$2' does not exist."; log "FAILED — '$2' not found"; exit 1; }
        [[ -d "$2" ]] && { echo "Error: '$2' is a directory. Only files can be deleted."; exit 1; }
        rm -f "$2"
        echo "Deleted: '$2'"
        log "Deleted — $2"
        ;;

    list)
        DIR="${2:-.}"
        [[ ! -d "$DIR" ]] && { echo "Error: '$DIR' is not a directory."; exit 1; }
        ls -lh "$DIR"
        log "Listed — $DIR"
        ;;

    rename)
        [[ $# -lt 3 ]] && { echo "Usage: $(basename "$0") rename <old> <new>"; exit 1; }
        [[ ! -e "$2" ]] && { echo "Error: '$2' does not exist."; log "FAILED — '$2' not found"; exit 1; }
        [[ -e "$3" ]] && { echo "Error: '$3' already exists."; log "FAILED — '$3' already exists"; exit 1; }
        mv "$2" "$3"
        echo "Renamed: '$2' -> '$3'"
        log "Renamed — '$2' -> '$3'"
        ;;

    *)
        echo "Unknown command: '$COMMAND'"
        usage
        ;;
esac
