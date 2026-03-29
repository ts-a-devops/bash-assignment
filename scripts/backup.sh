#!/bin/bash

# A script to backup a directory and keep only the last 5 backups.
# Logs activity to logs/backup.log

BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

mkdir -p "$BACKUP_DIR" logs

if [ -z "$1" ]; then
    echo "Usage: $0 [directory_to_backup]"
    exit 1
fi

TARGET_DIR=$1

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

echo "Starting backup of '$TARGET_DIR'..."
tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$TARGET_DIR" .

if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_DIR/$BACKUP_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - BACKUP SUCCESS: $TARGET_DIR to $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "Error: Backup failed."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - BACKUP FAILURE: $TARGET_DIR" >> "$LOG_FILE"
    exit 1
fi

# Keep only the last 5 backups
OLD_BACKUPS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6)
if [ -n "$OLD_BACKUPS" ]; then
    echo "Deleting old backups:"
    echo "$OLD_BACKUPS"
    echo "$OLD_BACKUPS" | xargs rm -f
    echo "$(date '+%Y-%m-%d %H:%M:%S') - CLEANED: Deleted old backups" >> "$LOG_FILE"
fi
