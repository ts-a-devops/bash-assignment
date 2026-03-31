#!/bin/bash

#Get script directory (important for stability)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BASE_DIR="$SCRIPT_DIR/.."
LOG_DIR="$BASE_DIR/logs"
BACKUPS_DIR="$BASE_DIR/backups"

# Ensure directories exist
mkdir -p "$LOG_DIR"
mkdir -p "$BACKUPS_DIR"

BACKUP_DIR="$1"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/backup.log"

log() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Validate input
if [[ -z "$BACKUP_DIR" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Error: Directory '$BACKUP_DIR' does not exist."
    exit 1
fi

# Extract folder name (this is the key change 🔥)
FOLDER_NAME=$(basename "$BACKUP_DIR")

# Create backup filename
BACKUP_FILE="$BACKUPS_DIR/backup_${FOLDER_NAME}_$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" -C "$(dirname "$BACKUP_DIR")" "$FOLDER_NAME"

if [[ $? -eq 0 ]]; then
    echo "Backup created: $BACKUP_FILE"
    log "Backup created: $BACKUP_FILE"
else
    echo "Backup failed!"
    log "Backup failed for $BACKUP_DIR"
    exit 1
fi

# Keep only last 5 backups (per folder type optional later)
BACKUP_COUNT=$(ls "$BACKUPS_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ $BACKUP_COUNT -gt 5 ]]; then
    OLD_BACKUPS=$(ls -t "$BACKUPS_DIR"/backup_*.tar.gz | tail -n +6)

    for old in $OLD_BACKUPS; do
        rm "$old"
        log "Deleted old backup: $old"
    done
fi

