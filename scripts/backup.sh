#!/bin/bash

# Directories
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Input directory
SOURCE_DIR=$1

# Validate input
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: Please provide a directory to back up."
    exit 1
fi

# Check if directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup file name
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
    echo "Backup created: $BACKUP_FILE"
    echo "$(date): SUCCESS - Backup created for $SOURCE_DIR → $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "Error: Backup failed."
    echo "$(date): ERROR - Backup failed for $SOURCE_DIR" >> "$LOG_FILE"
    exit 1
fi

# Keep only last 5 backups
echo "Cleaning up old backups..."

ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read old_file; do
    rm -f "$old_file"
    echo "$(date): DELETED - Old backup removed: $old_file" >> "$LOG_FILE"
done

echo "Backup process completed."