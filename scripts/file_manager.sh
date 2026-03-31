#!/usr/bin/env bash
# file_manager.sh — create / delete / list / rename files with logging.
#
# Usage:
#   ./file_manager.sh create  <filename>
#   ./file_manager.sh delete  <filename>
#   ./file_manager.sh list    [directory]
#   ./file_manager.sh rename  <old_name> <new_name>

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/file_manager.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] ${*:2}" | tee -a "$LOG_FILE"
}

usage() {
    echo "Usage:"
    echo "  $0 create  <filename>"
    echo "  $0 delete  <filename>"
    echo "  $0 list    [directory]"
    echo "  $0 rename  <old_name> <new_name>"
    exit 1
}

# ── Argument validation ───────────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    echo "Error: No command provided." >&2
    usage
fi

CMD="$1"

case "$CMD" in

    # ── CREATE ────────────────────────────────────────────────────────────────
    create)
        [[ $# -lt 2 ]] && { echo "Error: 'create' requires a filename." >&2; usage; }
        target="$2"
        if [[ -e "$target" ]]; then
            log "ERROR" "Cannot create '$target' — file already exists."
            echo "Error: '$target' already exists. Aborting to prevent overwrite." >&2
            exit 1
        fi
        touch "$target"
        log "INFO" "Created file: '$target'"
        echo "✔ Created: $target"
        ;;

    # ── DELETE ────────────────────────────────────────────────────────────────
    delete)
        [[ $# -lt 2 ]] && { echo "Error: 'delete' requires a filename." >&2; usage; }
        target="$2"
        if [[ ! -e "$target" ]]; then
            log "ERROR" "Cannot delete '$target' — file not found."
            echo "Error: '$target' does not exist." >&2
            exit 1
        fi
        rm -f "$target"
        log "INFO" "Deleted file: '$target'"
        echo "✔ Deleted: $target"
        ;;

    # ── LIST ──────────────────────────────────────────────────────────────────
    list)
        dir="${2:-.}"
        if [[ ! -d "$dir" ]]; then
            log "ERROR" "Cannot list '$dir' — directory not found."
            echo "Error: '$dir' is not a valid directory." >&2
            exit 1
        fi
        echo "Contents of '$dir':"
        ls -lah "$dir"
        log "INFO" "Listed directory: '$dir'"
        ;;

    # ── RENAME ────────────────────────────────────────────────────────────────
    rename)
        [[ $# -lt 3 ]] && { echo "Error: 'rename' requires <old_name> <new_name>." >&2; usage; }
        old="$2"
        new="$3"
        if [[ ! -e "$old" ]]; then
            log "ERROR" "Cannot rename '$old' — file not found."
            echo "Error: '$old' does not exist." >&2
            exit 1
        fi
        if [[ -e "$new" ]]; then
            log "ERROR" "Cannot rename to '$new' — destination already exists."
            echo "Error: '$new' already exists. Aborting to prevent overwrite." >&2
            exit 1
        fi
        mv "$old" "$new"
        log "INFO" "Renamed: '$old' → '$new'"
        echo "✔ Renamed: '$old' → '$new'"
        ;;

    *)
        echo "Error: Unknown command '$CMD'." >&2
        usage
        ;;
esac
