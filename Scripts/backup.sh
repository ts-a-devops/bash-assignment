#!/bin/bash

# Configuration
SOURCE_DIR=$1
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

# Ensure directories exist
mkdir -p "$BACKUP_DIR" logs

# 1. Validate Input
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# 2. Create Compressed Backup
echo "Starting backup of $SOURCE_DIR..."
if tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR" 2>/dev/null; then
    echo "Backup successful: $BACKUP_NAME"
    echo "$(date): SUCCESS - Backed up $SOURCE_DIR to $BACKUP_NAME" >> "$LOG_FILE"
else
    echo "Error: Backup failed."
    echo "$(date): FAILED - Could not backup $SOURCE_DIR" >> "$LOG_FILE"
    exit 1
fi

# 3. Retention: Keep only the last 5 backups
# Lists files by time (newest first), skips the first 5, and deletes the rest
ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -I {} rm {}

echo "Retention check complete. Only the 5 most recent backups kept."
