#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
LOG_FILE="$LOG_DIR/backup.log"
BACKUP_DIR="$(dirname "$0")/../backups"
MAX_BACKUPS=5

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

[[ $# -lt 1 ]] && { echo "Usage: $(basename "$0") <directory>"; exit 1; }

SOURCE="$1"

[[ ! -e "$SOURCE" ]] && { echo "Error: '$SOURCE' does not exist."; exit 1; }
[[ ! -d "$SOURCE" ]] && { echo "Error: '$SOURCE' is not a directory."; exit 1; }
[[ ! -r "$SOURCE" ]] && { echo "Error: No read permission for '$SOURCE'."; exit 1; }

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BASENAME=$(basename "$SOURCE")
ARCHIVE="$BACKUP_DIR/backup_${BASENAME}_${TIMESTAMP}.tar.gz"

log "Starting backup — Source: $SOURCE"

if tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$BASENAME" 2>/dev/null; then
    SIZE=$(du -sh "$ARCHIVE" | cut -f1)
    log "Backup created — $(basename "$ARCHIVE") ($SIZE)"
    echo "Backup created: $(basename "$ARCHIVE") ($SIZE)"
else
    log "ERROR — tar failed for '$SOURCE'"
    echo "Error: Backup failed."
    exit 1
fi

# Keep only the last MAX_BACKUPS backups
mapfile -t ALL_BACKUPS < <(ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null)
TOTAL=${#ALL_BACKUPS[@]}

if (( TOTAL > MAX_BACKUPS )); then
    for (( i = MAX_BACKUPS; i < TOTAL; i++ )); do
        rm -f "${ALL_BACKUPS[$i]}"
        log "Removed old backup — $(basename "${ALL_BACKUPS[$i]}")"
        echo "Removed: $(basename "${ALL_BACKUPS[$i]}")"
    done
fi

REMAINING=$(ls "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
log "Done. $REMAINING backup(s) stored."
echo "Backups stored: $REMAINING / $MAX_BACKUPS"
