#!/bin/bash

TARGET_DIR="$1"
BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

if [ -z "$TARGET_DIR" ] || [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Valid directory required."
    echo "$(date): Invalid directory input" >> "$LOG_FILE"
    exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$TARGET_DIR"

echo "$(date): Created backup $BACKUP_FILE" >> "$LOG_FILE"

# Keep last 5 backups
cd "$BACKUP_DIR"
ls -1t | tail -n +6 | xargs -I {} rm -- {}
