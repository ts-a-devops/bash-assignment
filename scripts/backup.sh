#!/bin/bash

SOURCE_DIR=$1
LOG_FILE="logs/backup.log"
TIME=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/backup_$TIME.tar.gz"

# Check if directory exists
if [ ! -d "$SOURCE_DIR" ]; then
   echo "Error: Directory does not exist."
    exit 1
fi

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"
echo "Backup created: $BACKUP_FILE"
echo "$(date): Backup created $BACKUP_FILE" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t backups/backup_*.tar.gz | tail -n +6 | xargs rm -f
