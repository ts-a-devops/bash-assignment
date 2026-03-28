#!/bin/bash

# Variables
DIR=$1
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="../backups/backup_$TIMESTAMP.tar.gz"
LOG_FILE="../logs/backup.log"

# Check if directory is provided
if [ -z "$DIR" ]; then
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

# Check if directory exists
if [ ! -d "$DIR" ]; then
    echo "Directory does not exist!"
    exit 1
fi

# Create backup
mkdir -p ../backups
tar -czf "$BACKUP_FILE" "$DIR"

echo "Backup created: $BACKUP_FILE" | tee -a "$LOG_FILE"

# Keep only last 5 backups
cd ../backups || exit

ls -t | tail -n +6 | while read file; do
    rm "$file"
    echo "Deleted old backup: $file" >> "$LOG_FILE"
done

echo "Backup process completed." | tee -a "$LOG_FILE"
