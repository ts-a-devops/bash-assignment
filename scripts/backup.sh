#!/bin/bash

mkdir -p backups logs

LOG_FILE="logs/backup.log"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Get source directory from argument OR prompt
SOURCE_DIR="${1:-}"

if [[ -z "$SOURCE_DIR" ]]; then
    read -p "Enter directory to back up: " SOURCE_DIR
fi

# Validate input
if [[ -z "$SOURCE_DIR" ]]; then
    log "ERROR: No directory provided."
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

# Check if directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    log "ERROR: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
    log "SUCCESS: Backup created at $BACKUP_FILE"
else
    log "ERROR: Failed to create backup."
    exit 1
fi

# Cleanup old backups (keep last 5)
log "Cleaning old backups (keeping last 5)..."

ls -1t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read OLD_BACKUP; do
    rm -f "$OLD_BACKUP"
    log "Deleted old backup: $OLD_BACKUP"
done

log "Backup process completed."
