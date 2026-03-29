#!/bin/bash

BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

mkdir -p "$BACKUP_DIR"
mkdir -p logs

# Check input
if [ -z "$1" ]; then
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

SOURCE_DIR="$1"

# Validate directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory does not exist"
    exit 1
fi

# Create backup file
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup created: $BACKUP_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - BACKUP CREATED: $BACKUP_FILE" >> "$LOG_FILE"

# Keep only last 5 backups
ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read file; do
    rm -f "$file"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - DELETED OLD BACKUP: $file" >> "$LOG_FILE"
done
