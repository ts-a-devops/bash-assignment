#!/bin/bash
# backup.sh - Creates compressed backups of a directory
# Written by Dave Woks

set -uo pipefail

mkdir -p ~/bash-assignment/logs
mkdir -p ~/bash-assignment/backups
LOGFILE=~/bash-assignment/logs/backup.log
BACKUP_DIR=~/bash-assignment/backups

log_action() {
    echo "[$(date +%F\ %T)] $1" >> "$LOGFILE"
}

# --- Validate input ---
if [[ $# -lt 1 ]]; then
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

SOURCE=$1

if [[ ! -d "$SOURCE" ]]; then
    echo "Error: $SOURCE is not a valid directory."
    log_action "ERROR: Invalid directory: $SOURCE"
    exit 1
fi


# --- Create backup ---
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE"
echo "Backup created: $BACKUP_FILE"
log_action "Backup created: $BACKUP_FILE from $SOURCE"

# --- Keep only last 5 backups ---
BACKUP_COUNT=$(ls "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
if [[ $BACKUP_COUNT -gt 5 ]]; then
    ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs rm -f
    echo "Old backups cleaned up. Keeping last 5."
    log_action "Old backups removed. Keeping last 5."
fi

echo "Done. Total backups: $(ls "$BACKUP_DIR"/backup_*.tar.gz | wc -l)"
