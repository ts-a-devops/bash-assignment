#!/bin/bash

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"

mkdir -p "$BACKUP_DIR" logs

# Redirect output to log + terminal
exec > >(tee -a "$LOG_FILE") 2>&1

# Timestamp function
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Input argument
SOURCE_DIR="$1"

# Validate input
if [[ -z "$SOURCE_DIR" ]]; then
    echo "$(timestamp) ERROR: No directory provided"
    exit 1
fi

# Validate directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "$(timestamp) ERROR: Directory '$SOURCE_DIR' does not exist"
    exit 1
fi

# Generate backup filename
TIME=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_$TIME.tar.gz"

# Create backup
echo "$(timestamp) INFO: Starting backup of '$SOURCE_DIR'..."
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# Check if tar succeeded
if [[ $? -eq 0 ]]; then
    echo "$(timestamp) SUCCESS: Backup created at '$BACKUP_FILE'"
else
    echo "$(timestamp) ERROR: Backup failed"
    exit 1
fi

# Keep only last 5 backups
echo "$(timestamp) INFO: Cleaning old backups..."

ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read file; do
    echo "$(timestamp) INFO: Deleting old backup '$file'"
    rm -f "$file"
done

echo "$(timestamp) INFO: Backup process completed"
