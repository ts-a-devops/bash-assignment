#!/bin/bash

# Directories
BACKUP_DIR="../backups"
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/backup.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# Input directory
SOURCE_DIR=$1

# Validate input
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: Please provide a directory to back up."
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Create timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup file name
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Perform backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") - SUCCESS: Backup created -> $BACKUP_FILE" | tee -a "$LOG_FILE"
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") - ERROR: Backup failed for $SOURCE_DIR" | tee -a "$LOG_FILE"
    exit 1
fi

# Keep only last 5 backups
cd "$BACKUP_DIR" || exit
ls -1t backup_*.tar.gz | tail -n +6 | while read file; do
    rm -f "$file"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - DELETED old backup: $file" >> "$LOG_FILE"
done

echo "Backup completed successfully."
