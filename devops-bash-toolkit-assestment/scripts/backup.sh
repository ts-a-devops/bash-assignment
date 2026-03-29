#!/bin/bash

#Ensure directories exist
mkdir -p ../logs
mkdir -p ../backups

BACKUP_DIR="$1"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="../logs/backup.log"

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

# Create backup
BACKUP_FILE="../backups/backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_FILE" -C "$BACKUP_DIR" .
if [[ $? -eq 0 ]]; then
    echo "Backup created: $BACKUP_FILE"
    log "Backup created: $BACKUP_FILE"
else
    echo "Backup failed!"
    log "Backup failed for $BACKUP_DIR"
    exit 1
fi

# Keep only last 5 backups
BACKUP_COUNT=$(ls ../backups/backup_*.tar.gz 2>/dev/null | wc -l)
if [[ $BACKUP_COUNT -gt 5 ]]; then
    OLD_BACKUPS=$(ls -t ../backups/backup_*.tar.gz | tail -n +6)
    for old in $OLD_BACKUPS; do
        rm "$old"
        log "Deleted old backup: $old"
    done
fi

