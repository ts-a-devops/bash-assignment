#!/bin/bash
# =============================================================================
# file_manager.sh - Simple file manager: create | delete | list | rename
# Usage:
#   ./file_manager.sh create <file>
#   ./file_manager.sh delete <file>
#   ./file_manager.sh list   [directory]
#   ./file_manager.sh rename <old> <new>
# =============================================================================

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p "$LOG_DIR"

# ── Helper: timestamped log ───────────────────────────────────────────────────
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Helper: print usage and exit ─────────────────────────────────────────────
usage() {
    echo "Usage:"
    echo "  $0 create <file>"
    echo "  $0 delete <file>"
    echo "  $0 list   [directory]"
    echo "  $0 rename <old_name> <new_name>"
    exit 1
}

# ── Validate at least one argument ───────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    echo "  ✖  No command provided."
    usage
fi

COMMAND="$1"

# ── Dispatch ──────────────────────────────────────────────────────────────────
case "$COMMAND" in

    # ── CREATE ──────────────────────────────────────────────────────────────
    create)
        if [[ $# -lt 2 ]]; then
            echo "  ✖  'create' requires a filename."
            usage
        fi
        TARGET="$2"
        if [[ -e "$TARGET" ]]; then
            echo "  ✖  File '$TARGET' already exists. Overwrite prevented."
            log "CREATE FAILED — '$TARGET' already exists."
            exit 1
        fi
        touch "$TARGET"
        echo "  ✔  File '$TARGET' created successfully."
        log "CREATE — '$TARGET' created."
        ;;

    # ── DELETE ──────────────────────────────────────────────────────────────
    delete)
        if [[ $# -lt 2 ]]; then
            echo "  ✖  'delete' requires a filename."
            usage
        fi
        TARGET="$2"
        if [[ ! -e "$TARGET" ]]; then
            echo "  ✖  File '$TARGET' does not exist."
            log "DELETE FAILED — '$TARGET' not found."
            exit 1
        fi
        rm -rf "$TARGET"
        echo "  ✔  '$TARGET' deleted successfully."
        log "DELETE — '$TARGET' deleted."
        ;;

    # ── LIST ────────────────────────────────────────────────────────────────
    list)
        DIR="${2:-.}"          # default to current directory
        if [[ ! -d "$DIR" ]]; then
            echo "  ✖  Directory '$DIR' does not exist."
            log "LIST FAILED — directory '$DIR' not found."
            exit 1
        fi
        echo "  Contents of '$DIR':"
        echo "  --------------------------------------------"
        ls -lah "$DIR"
        echo "  --------------------------------------------"
        log "LIST — listed contents of '$DIR'."
        ;;

    # ── RENAME ──────────────────────────────────────────────────────────────
    rename)
        if [[ $# -lt 3 ]]; then
            echo "  ✖  'rename' requires <old_name> and <new_name>."
            usage
        fi
        OLD="$2"
        NEW="$3"
        if [[ ! -e "$OLD" ]]; then
            echo "  ✖  Source '$OLD' does not exist."
            log "RENAME FAILED — '$OLD' not found."
            exit 1
        fi
        if [[ -e "$NEW" ]]; then
            echo "  ✖  Destination '$NEW' already exists. Overwrite prevented."
            log "RENAME FAILED — '$NEW' already exists."
            exit 1
        fi
        mv "$OLD" "$NEW"
        echo "  ✔  Renamed '$OLD' → '$NEW'."
        log "RENAME — '$OLD' renamed to '$NEW'."
        ;;

    # ── UNKNOWN ─────────────────────────────────────────────────────────────
    *)
        echo "  ✖  Unknown command: '$COMMAND'."
        usage
        ;;
esac