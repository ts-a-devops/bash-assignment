#!/bin/bash

set -euo pipefail

BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"
TIMESTAMP=$(date +%F_%H-%M-%S)

mkdir -p "$BACKUP_DIR"
mkdir -p logs

DIR_TO_BACKUP=${1:-}

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Validate input
if [[ -z "$DIR_TO_BACKUP" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [[ ! -d "$DIR_TO_BACKUP" ]]; then
    echo "Error: Directory does not exist"
    log "FAILED backup - directory not found: $DIR_TO_BACKUP"
    exit 1
fi

# Backup name
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" "$DIR_TO_BACKUP"

echo "Backup created: $BACKUP_FILE"
log "SUCCESS backup created: $BACKUP_FILE"

# Keep only last 5 backups
cd "$BACKUP_DIR"
ls -1t backup_*.tar.gz | tail -n +6 | while read old_backup; do
    rm -f "$old_backup"
    log "Deleted old backup: $old_backup"
done
cd ..

echo "Backup complete."
