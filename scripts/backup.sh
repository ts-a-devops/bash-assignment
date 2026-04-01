#!/usr/bin/env bash
# backup.sh - Create compressed backups with automatic rotation
# Usage: ./backup.sh <source_directory>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$ROOT_DIR/backups"
LOG_DIR="$ROOT_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"
MAX_BACKUPS=5

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log() {
  local level=$1; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

usage() {
  echo "Usage: $0 <source_directory>"
  exit 1
}

SOURCE="${1:-}"
[[ -z "$SOURCE" ]] && { echo "  No source directory specified."; usage; }

# Resolve absolute path
SOURCE="$(cd "$SOURCE" 2>/dev/null && pwd)" || {
  echo "  Directory '$SOURCE' does not exist or is not accessible."
  log "ERROR" "Source directory not found: ${1:-}"
  exit 1
}

log "INFO" "Starting backup of: $SOURCE"

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

echo "📦  Creating backup: $ARCHIVE_NAME"
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

ARCHIVE_SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
log "INFO" "Backup created: $ARCHIVE_PATH (size: $ARCHIVE_SIZE)"
echo "  Backup created: $ARCHIVE_PATH ($ARCHIVE_SIZE)"

echo
echo "  Rotating backups (keeping last $MAX_BACKUPS)..."

mapfile -t ALL_BACKUPS < <(ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null)
TOTAL=${#ALL_BACKUPS[@]}

if (( TOTAL > MAX_BACKUPS )); then
  DELETE_COUNT=$(( TOTAL - MAX_BACKUPS ))
  for (( i = MAX_BACKUPS; i < TOTAL; i++ )); do
    OLD="${ALL_BACKUPS[$i]}"
    rm -f "$OLD"
    log "INFO" "Rotated (deleted old backup): $OLD"
    echo "   Removed old backup: $(basename "$OLD")"
  done
  echo "  Removed $DELETE_COUNT old backup(s)."
else
  echo "  No rotation needed ($TOTAL/$MAX_BACKUPS backups stored)."
fi

echo
echo "========================================"
echo "  Backup Summary"
echo "========================================"
echo "  Source  : $SOURCE"
echo "  Archive : $ARCHIVE_PATH"
echo "  Size    : $ARCHIVE_SIZE"
echo "  Stored  : $(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l) backup(s)"
echo "========================================"
log "INFO" "Backup complete — $ARCHIVE_PATH"
