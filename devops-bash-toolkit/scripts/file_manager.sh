#!/bin/bash
# ─────────────────────────────────────────
#  file_manager.sh - File management tool
# ─────────────────────────────────────────

# ── Log file ──
LOG_FILE="logs/file_manager.log"

# ── Create logs folder if it doesn't exist ──
mkdir -p logs

# ── Timestamp ──
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# ── Function to print and log ──
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

# ── Check if a command was provided ──
if [[ -z "$1" ]]; then
  log "[$TIMESTAMP] Error: No command provided."
  echo ""
  echo "Usage:"
  echo "  ./file_manager.sh create <filename>"
  echo "  ./file_manager.sh delete <filename>"
  echo "  ./file_manager.sh list <directory>"
  echo "  ./file_manager.sh rename <oldname> <newname>"
  exit 1
fi

# ── Get command ──
COMMAND=$1

# ─────────────────────────────────────────
# CREATE
# ─────────────────────────────────────────
if [[ "$COMMAND" == "create" ]]; then

  # Check if filename was provided
  if [[ -z "$2" ]]; then
    log "[$TIMESTAMP] Error: No filename provided for create."
    exit 1
  fi

  FILENAME=$2

  # Prevent overwriting existing files
  if [[ -e "$FILENAME" ]]; then
    log "[$TIMESTAMP] Error: File '$FILENAME' already exists. Cannot overwrite."
    exit 1
  fi

  # Create the file
  touch "$FILENAME"
  log "[$TIMESTAMP] SUCCESS: File '$FILENAME' created."

# ─────────────────────────────────────────
# DELETE
# ─────────────────────────────────────────
elif [[ "$COMMAND" == "delete" ]]; then

  # Check if filename was provided
  if [[ -z "$2" ]]; then
    log "[$TIMESTAMP] Error: No filename provided for delete."
    exit 1
  fi

  FILENAME=$2

  # Check if file exists
  if [[ ! -e "$FILENAME" ]]; then
    log "[$TIMESTAMP] Error: File '$FILENAME' does not exist."
    exit 1
  fi

  # Delete the file
  rm "$FILENAME"
  log "[$TIMESTAMP] SUCCESS: File '$FILENAME' deleted."

# ─────────────────────────────────────────
# LIST
# ─────────────────────────────────────────
elif [[ "$COMMAND" == "list" ]]; then

  # Use current directory if none provided
  DIR=${2:-.}

  # Check if directory exists
  if [[ ! -d "$DIR" ]]; then
    log "[$TIMESTAMP] Error: Directory '$DIR' does not exist."
    exit 1
  fi

  # List files
  log "[$TIMESTAMP] SUCCESS: Listing files in '$DIR':"
  ls -lh "$DIR" | tee -a "$LOG_FILE"

# ─────────────────────────────────────────
# RENAME
# ─────────────────────────────────────────
elif [[ "$COMMAND" == "rename" ]]; then

  # Check if both names were provided
  if [[ -z "$2" || -z "$3" ]]; then
    log "[$TIMESTAMP] Error: Please provide both old and new filename."
    echo "Usage: ./file_manager.sh rename <oldname> <newname>"
    exit 1
  fi

  OLDNAME=$2
  NEWNAME=$3

  # Check if old file exists
  if [[ ! -e "$OLDNAME" ]]; then
    log "[$TIMESTAMP] Error: File '$OLDNAME' does not exist."
    exit 1
  fi

  # Prevent overwriting existing file
  if [[ -e "$NEWNAME" ]]; then
    log "[$TIMESTAMP] Error: File '$NEWNAME' already exists. Cannot overwrite."
    exit 1
  fi

  # Rename the file
  mv "$OLDNAME" "$NEWNAME"
  log "[$TIMESTAMP] SUCCESS: File '$OLDNAME' renamed to '$NEWNAME'."

# ─────────────────────────────────────────
# UNKNOWN COMMAND
# ─────────────────────────────────────────
else
  log "[$TIMESTAMP] Error: Unknown command '$COMMAND'."
  echo ""
  echo "Available commands:"
  echo "  create  - Create a new file"
  echo "  delete  - Delete an existing file"
  echo "  list    - List files in a directory"
  echo "  rename  - Rename a file"
  exit 1
fi
