#!/usr/bin/env bash
# =============================================================================
# file_manager.sh — Manages files with create, delete, list, and rename
#                   commands. Prevents overwrites and logs all actions.
#
# Usage:
#   ./file_manager.sh create <filename>
#   ./file_manager.sh delete <filename>
#   ./file_manager.sh list   [directory]
#   ./file_manager.sh rename <old_name> <new_name>
# =============================================================================
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_ROOT/logs"
LOG_FILE="$LOG_DIR/file_manager.log"

# ── Ensure log directory exists ───────────────────────────────────────────────
mkdir -p "$LOG_DIR"

# ── Logging helper ────────────────────────────────────────────────────────────
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# ── Usage / help ──────────────────────────────────────────────────────────────
usage() {
    echo ""
    echo "Usage:"
    echo "  $(basename "$0") create <filename>"
    echo "  $(basename "$0") delete <filename>"
    echo "  $(basename "$0") list   [directory]"
    echo "  $(basename "$0") rename <old_name> <new_name>"
    echo ""
}

# ── CREATE ────────────────────────────────────────────────────────────────────
cmd_create() {
    local target="$1"

    # Prevent overwriting an existing file
    if [[ -e "$target" ]]; then
        log "ERROR" "Create failed — '$target' already exists."
        echo "  ✗  '$target' already exists. Use a different name or delete it first." >&2
        exit 1
    fi

    # Create the file (touch creates an empty file)
    touch "$target"
    log "INFO" "Created file: '$target'"
    echo "  ✔  File '$target' created successfully."
}

# ── DELETE ────────────────────────────────────────────────────────────────────
cmd_delete() {
    local target="$1"

    # Ensure the file exists before attempting deletion
    if [[ ! -e "$target" ]]; then
        log "ERROR" "Delete failed — '$target' does not exist."
        echo "  ✗  '$target' not found." >&2
        exit 1
    fi

    rm -f "$target"
    log "INFO" "Deleted file: '$target'"
    echo "  ✔  File '$target' deleted successfully."
}

# ── LIST ──────────────────────────────────────────────────────────────────────
cmd_list() {
    # Default to current directory if none provided
    local dir="${1:-.}"

    if [[ ! -d "$dir" ]]; then
        log "ERROR" "List failed — '$dir' is not a valid directory."
        echo "  ✗  '$dir' is not a directory." >&2
        exit 1
    fi

    echo ""
    echo "  Contents of: $dir"
    echo "  ─────────────────────────────────────"
    ls -lh "$dir"
    echo ""
    log "INFO" "Listed contents of directory: '$dir'"
}

# ── RENAME ────────────────────────────────────────────────────────────────────
cmd_rename() {
    local old_name="$1"
    local new_name="$2"

    # Source must exist
    if [[ ! -e "$old_name" ]]; then
        log "ERROR" "Rename failed — source '$old_name' does not exist."
        echo "  ✗  '$old_name' not found." >&2
        exit 1
    fi

    # Prevent overwriting an existing destination
    if [[ -e "$new_name" ]]; then
        log "ERROR" "Rename failed — destination '$new_name' already exists."
        echo "  ✗  '$new_name' already exists. Choose a different name." >&2
        exit 1
    fi

    mv "$old_name" "$new_name"
    log "INFO" "Renamed '$old_name' → '$new_name'"
    echo "  ✔  Renamed '$old_name' to '$new_name' successfully."
}

# ── Main dispatcher ───────────────────────────────────────────────────────────
main() {
    # Require at least one argument (the command)
    if [[ $# -lt 1 ]]; then
        log "ERROR" "No command provided."
        usage
        exit 1
    fi

    local command="$1"
    shift  # Remove command from argument list; remaining args are operands

    log "INFO" "=== file_manager.sh called with command: '$command' ==="

    case "$command" in
        create)
            if [[ $# -lt 1 ]]; then
                echo "  ✗  'create' requires a filename." >&2
                usage; exit 1
            fi
            cmd_create "$1"
            ;;
        delete)
            if [[ $# -lt 1 ]]; then
                echo "  ✗  'delete' requires a filename." >&2
                usage; exit 1
            fi
            cmd_delete "$1"
            ;;
        list)
            # Directory argument is optional
            cmd_list "${1:-}"
            ;;
        rename)
            if [[ $# -lt 2 ]]; then
                echo "  ✗  'rename' requires <old_name> and <new_name>." >&2
                usage; exit 1
            fi
            cmd_rename "$1" "$2"
            ;;
        *)
            log "ERROR" "Unknown command: '$command'"
            echo "  ✗  Unknown command: '$command'" >&2
            usage
            exit 1
            ;;
    esac
}

main "$@"
