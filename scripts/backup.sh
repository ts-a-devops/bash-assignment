#!/bin/bash

# Ensure backup and log directories exist
mkdir -p backups
mkdir -p logs
LOG_FILE="logs/backup.log"

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

SOURCE_DIR="$1"

# Validate directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory $SOURCE_DIR does not exist."
    exit 1
fi

# Create timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .
echo "Backup created: $BACKUP_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created: $BACKUP_FILE" >> "$LOG_FILE"

# Keep only last 5 backups
BACKUPS_TO_KEEP=5
BACKUP_COUNT=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$BACKUPS_TO_KEEP" ]; then
    # Find and delete oldest backups
    OLD_BACKUPS=$(ls -1t backups/backup_*.tar.gz | tail -n +$((BACKUPS_TO_KEEP + 1)))
    for file in $OLD_BACKUPS; do
        rm "$file"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Old backup deleted: $file" >> "$LOG_FILE"
    done
fi
