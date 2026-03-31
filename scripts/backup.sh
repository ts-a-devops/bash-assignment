#!/bin/bash

LOG_FILE="../logs/backup.log"
BACKUP_DIR="../backups"
SOURCE_DIR=$1

mkdir -p "$BACKUP_DIR"
mkdir -p $(dirname "$LOG_FILE")

# Check if directory argument was provided
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: No directory provided."
    echo "Usage: ./backup.sh /path/to/directory"
    exit 1
fi

# Validate directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create timestamp and backup filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create compressed backup
echo "Creating backup of '$SOURCE_DIR'..."
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
    echo "Backup created successfully: $BACKUP_FILE"
    echo "$(date): BACKUP SUCCESS - $SOURCE_DIR -> $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "Error: Backup failed."
    echo "$(date): BACKUP FAILED - $SOURCE_DIR" >> "$LOG_FILE"
    exit 1
fi

# Keep only last 5 backups
echo "Checking old backups..."
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ $BACKUP_COUNT -gt 5 ]]; then
    ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | while read OLD_BACKUP; do
        rm "$OLD_BACKUP"
        echo "Deleted old backup: $OLD_BACKUP"
        echo "$(date): DELETED OLD BACKUP - $OLD_BACKUP" >> "$LOG_FILE"
    done
fi

echo "Done! Total backups kept: $(ls -1 "$BACKUP_DIR"/backup_*.tar.gz | wc -l)"
