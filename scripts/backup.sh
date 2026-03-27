#!/bin/bash
# scripts/backup.sh
SOURCE_DIR=$1
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p logs

# 1. Validate that the directory exists
if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Please provide a directory to backup."
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# 2. Create compressed backup: backup_<timestamp>.tar.gz
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

echo "Starting backup of $SOURCE_DIR..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_NAME"
    echo "$(date): SUCCESS - Created $BACKUP_NAME from $SOURCE_DIR" >> "$LOG_FILE"
else
    echo "Backup failed!"
    echo "$(date): FAILED - Backup of $SOURCE_DIR" >> "$LOG_FILE"
    exit 1
fi

# 3. Keep only the last 5 backups (delete older ones)
echo "Cleaning up old backups (keeping last 5)..."
# List backups by time (newest first), skip the first 5, and delete the rest
ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm --

echo "Backup process complete."
