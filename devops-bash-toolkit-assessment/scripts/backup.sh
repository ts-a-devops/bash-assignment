#!/usr/bin/env bash

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"

# Ensure required directories exist
mkdir -p logs
mkdir -p "$BACKUP_DIR"

# Validate input
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

SOURCE_DIR=$1

# Check if directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup filename
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
    echo "Backup successful: $BACKUP_FILE"
    echo "$(date): BACKUP SUCCESS - $SOURCE_DIR -> $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "Backup failed."
    echo "$(date): BACKUP FAILED - $SOURCE_DIR" >> "$LOG_FILE"
    exit 1
fi

# Keep only last 5 backups
echo "Cleaning old backups..."

ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read old_backup; do
    rm -f "$old_backup"
    echo "$(date): DELETED OLD BACKUP - $old_backup" >> "$LOG_FILE"
done

echo "Backup process completed."