#!/bin/bash

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"

# =====  Creating Directory ====
mkdir -p $BACKUP_DIR

SOURCE_DIR=$1

# ==== Validates input ====
if [ -z "$SOURCE_DIR" ]; then
    echo "Error: Please provide a directory to back up."
    exit 1
fi

# ==== Checks if directory exists ====
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory does not exist."
    echo "$(date) - BACKUP FAILED: $SOURCE_DIR not found" >> $LOG_FILE
    exit 1
fi

# ==== Creates timestamp ====
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# ==== Creates compressed backup ====
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_FILE"
    echo "$(date) - BACKUP SUCCESS: $SOURCE_DIR -> $BACKUP_FILE" >> $LOG_FILE
else
    echo "Error: Backup failed."
    echo "$(date) - BACKUP FAILED: $SOURCE_DIR" >> $LOG_FILE
    exit 1
fi

# ==== Keeps only last 5 backups ====
cd $BACKUP_DIR

ls -t backup_*.tar.gz | tail -n +6 | while read file
do
    rm "$file"
    echo "$(date) - OLD BACKUP REMOVED: $file" >> "../$LOG_FILE"
done
