#!/usr/bin/env bash
# backup.sh — Compress a directory, store in backups/, keep only last 5.
#
# Usage: ./backup.sh <directory_to_backup>

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
BACKUP_DIR="$SCRIPT_DIR/../backups"
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/backup.log"
MAX_BACKUPS=5

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] ${*:2}" | tee -a "$LOG_FILE"
}

# ── Argument validation ───────────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <directory_to_backup>" >&2
    log "ERROR" "No directory argument provided."
    exit 1
fi

SOURCE_DIR="${1%/}"   # strip trailing slash

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: '$SOURCE_DIR' is not a valid directory." >&2
    log "ERROR" "Source directory not found: '$SOURCE_DIR'"
    exit 1
fi

# ── Create backup ─────────────────────────────────────────────────────────────
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

echo "Backing up '$SOURCE_DIR' → '$ARCHIVE_PATH' ..."
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
log "INFO" "Backup created: '$ARCHIVE_PATH' (size: $SIZE)"
echo "✔ Backup created: $ARCHIVE_NAME ($SIZE)"

# ── Prune old backups (keep only MAX_BACKUPS) ─────────────────────────────────
mapfile -t old_backups < <(ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null)

if (( ${#old_backups[@]} > MAX_BACKUPS )); then
    to_delete=("${old_backups[@]:$MAX_BACKUPS}")
    for f in "${to_delete[@]}"; do
        rm -f "$f"
        log "INFO" "Pruned old backup: '$f'"
        echo "  Removed old backup: $(basename "$f")"
    done
fi

remaining=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
log "INFO" "Backup complete. $remaining backup(s) retained (max: $MAX_BACKUPS)."
echo "Backups retained: $remaining / $MAX_BACKUPS"
