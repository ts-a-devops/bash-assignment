#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
BACKUP_DIR="$PROJECT_ROOT/backups"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

SOURCE_DIR="$1"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: '$SOURCE_DIR' is not a valid directory."
  log "ERROR - Backup failed. Invalid directory: '$SOURCE_DIR'"
  exit 1
fi

timestamp="$(date '+%Y%m%d_%H%M%S')"
backup_file="$BACKUP_DIR/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

echo "Backup created: $backup_file"
log "BACKUP - Source '$SOURCE_DIR' saved as '$backup_file'"

mapfile -t existing_backups < <(ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null || true)

if (( ${#existing_backups[@]} > 5 )); then
  for old_backup in "${existing_backups[@]:5}"; do
    rm -f -- "$old_backup"
    echo "Deleted old backup: $old_backup"
    log "CLEANUP - Deleted old backup '$old_backup'"
  done
fi
