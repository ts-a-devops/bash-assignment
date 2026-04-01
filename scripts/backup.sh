#!/bin/bash

# Configuration
SOURCE_DIR=$1
BACKUP_DIR="backups"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
LOG_FILE="logs/backup.log"

# Create necessary directories
mkdir -p "$BACKUP_DIR" logs

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# 1. Validate Input and Directory Existence
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    log_action "ERROR: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# 2. Create Compressed Backup (tar.gz)
# -c: create, -z: gzip, -f: file
if tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"; then
    log_action "SUCCESS: Backup created: $BACKUP_NAME"
else
    log_action "ERROR: Backup failed."
    exit 1
fi

# 3. Keep only the last 5 backups
# List files by time (newest first), skip the first 5, delete the rest
OLD_BACKUPS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6)

if [[ -n "$OLD_BACKUPS" ]]; then
    echo "Cleaning up old backups..."
    for file in $OLD_BACKUPS; do
        rm "$file"
        log_action "DELETED OLD BACKUP: $(basename "$file")"
    done
fi

echo "Done. Current backups in $BACKUP_DIR:"
ls -1 "$BACKUP_DIR"
