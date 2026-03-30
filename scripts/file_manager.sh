#!/bin/bash

# ── Setup ─────────────────────────────────────
LOG_FILE="../logs/file_manager.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")


# ── Helpers ───────────────────────────────────
log() {
  local level="$1"
  local msg="$2"
  echo "[$TIMESTAMP] [$level] $msg" | tee -a "$LOG_FILE"
}

info()    { log "INFO " "$1"; }
success() { log "OK   " "$1"; }
warn()    { log "WARN " "$1"; }
error()   { log "ERROR" "$1"; }

usage() {
  echo ""
  echo "Usage: ./file_manager.sh <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  create <filename>              Create a new file"
  echo "  delete <filename>              Delete an existing file"
  echo "  list   [directory]             List files in a directory (default: .)"
  echo "  rename <old_name> <new_name>   Rename or move a file"
  echo ""
  echo "Examples:"
  echo "  ./file_manager.sh create notes.txt"
  echo "  ./file_manager.sh delete notes.txt"
  echo "  ./file_manager.sh list ."
  echo "  ./file_manager.sh rename notes.txt archive.txt"
  echo ""
}

# ── Argument Guard ────────────────────────────
if [[ $# -lt 1 ]]; then
  error "No command provided."
  usage
  exit 1
fi

COMMAND="$1"

# ══════════════════════════════════════════════
#  COMMANDS
# ══════════════════════════════════════════════

case "$COMMAND" in

  # ── CREATE ──────────────────────────────────
  create)
    if [[ $# -lt 2 ]]; then
      error "create: missing filename. Usage: ./file_manager.sh create <filename>"
      exit 1
    fi

    FILENAME="$2"

    # Reject empty or dot-only names
    if [[ -z "$FILENAME" || "$FILENAME" == "." || "$FILENAME" == ".." ]]; then
      error "create: invalid filename '$FILENAME'."
      exit 1
    fi

    # Prevent overwriting existing file
    if [[ -e "$FILENAME" ]]; then
      warn "create: '$FILENAME' already exists. Overwrite prevented."
      exit 1
    fi

    # Ensure parent directory exists
    PARENT_DIR=$(dirname "$FILENAME")
    if [[ ! -d "$PARENT_DIR" ]]; then
      error "create: parent directory '$PARENT_DIR' does not exist."
      exit 1
    fi

    touch "$FILENAME"
    success "create: '$FILENAME' created successfully."
    ;;

  # ── DELETE ──────────────────────────────────
  delete)
    if [[ $# -lt 2 ]]; then
      error "delete: missing filename. Usage: ./file_manager.sh delete <filename>"
      exit 1
    fi

    FILENAME="$2"

    if [[ ! -e "$FILENAME" ]]; then
      error "delete: '$FILENAME' does not exist."
      exit 1
    fi

    if [[ -d "$FILENAME" ]]; then
      error "delete: '$FILENAME' is a directory. Only files are supported."
      exit 1
    fi

    rm "$FILENAME"
    success "delete: '$FILENAME' deleted successfully."
    ;;

  # ── LIST ────────────────────────────────────
  list)
    TARGET="${2:-.}"   # default to current directory

    if [[ ! -d "$TARGET" ]]; then
      error "list: '$TARGET' is not a valid directory."
      exit 1
    fi

    info "list: listing contents of '$TARGET'"
    echo ""
    echo "  Directory: $TARGET"
    echo "  -----------------------------------------"

    FILE_COUNT=0
    DIR_COUNT=0

    while IFS= read -r -d '' entry; do
      NAME=$(basename "$entry")
      if [[ -d "$entry" ]]; then
        echo "  [DIR]  $NAME"
        (( DIR_COUNT++ ))
      else
        SIZE=$(du -sh "$entry" 2>/dev/null | awk '{print $1}')
        echo "  [FILE] $NAME  ($SIZE)"
        (( FILE_COUNT++ ))
      fi
    done < <(find "$TARGET" -maxdepth 1 -mindepth 1 -print0 | sort -z)

    echo "  -----------------------------------------"
    echo "  $FILE_COUNT file(s), $DIR_COUNT dir(s)"
    echo ""

    success "list: '$TARGET' listed — $FILE_COUNT file(s), $DIR_COUNT dir(s)."
    ;;

  # ── RENAME ──────────────────────────────────
  rename)
    if [[ $# -lt 3 ]]; then
      error "rename: missing arguments. Usage: ./file_manager.sh rename <old> <new>"
      exit 1
    fi

    OLD_NAME="$2"
    NEW_NAME="$3"

    if [[ ! -e "$OLD_NAME" ]]; then
      error "rename: '$OLD_NAME' does not exist."
      exit 1
    fi

    if [[ -d "$OLD_NAME" ]]; then
      error "rename: '$OLD_NAME' is a directory. Only files are supported."
      exit 1
    fi

    # Prevent overwriting existing file
    if [[ -e "$NEW_NAME" ]]; then
      warn "rename: '$NEW_NAME' already exists. Overwrite prevented."
      exit 1
    fi

    # Ensure destination parent directory exists
    DEST_DIR=$(dirname "$NEW_NAME")
    if [[ ! -d "$DEST_DIR" ]]; then
      error "rename: destination directory '$DEST_DIR' does not exist."
      exit 1
    fi

    mv "$OLD_NAME" "$NEW_NAME"
    success "rename: '$OLD_NAME' renamed to '$NEW_NAME' successfully."
    ;;

  # ── UNKNOWN COMMAND ──────────────────────────
  *)
    error "Unknown command: '$COMMAND'."
    usage
    exit 1
    ;;

esac
