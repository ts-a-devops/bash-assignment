#!/bin/bash

# Create required directories if they don't exist
mkdir -p backups
mkdir -p logs

LOG_FILE="logs/backup.log"

# Get directory from user input
SOURCE_DIR=$1

# Timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

# Check if directory was provided
if [ -z "$SOURCE_DIR" ]; then
    echo "Please provide a directory to back up."
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

# Validate directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Directory does not exist."
    echo "[$(date)] Backup failed: directory $SOURCE_DIR not found." >> $LOG_FILE
    exit 1
fi

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup created: $BACKUP_FILE"
echo "[$(date)] Backup successful for $SOURCE_DIR -> $BACKUP_FILE" >> $LOG_FILE

# Keep only the last 5 backups
cd ../backups || exit

ls -t backup_*.tar.gz | tail -n +6 | while read file
do
    rm "$file"
    echo "[$(date)] Old backup removed: $file" >> ../logs/backup.log
done 
