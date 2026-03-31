#!/bin/bash

# Exit on error
set -e

# Ensure required directories exist
mkdir -p ../backups ../logs

LOG_FILE="../logs/backup.log"

# Validate input
if [ $# -lt 1 ]; then
	    echo "Usage: $0 <directory_to_backup>"
	        exit 1
fi

SOURCE_DIR=$1

# Check if directory exists
if [ ! -d "$SOURCE_DIR" ]; then
	    echo "Error: Directory does not exist."
	        echo "$(date) - BACKUP FAILED: $SOURCE_DIR not found" >> "$LOG_FILE"
		    exit 1
fi

# Create timestamp
TIMESTAMP=$(date +%F_%H-%M-%S)

# Backup file name
BACKUP_FILE="../backups/backup_${TIMESTAMP}.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup created: $BACKUP_FILE"
echo "$(date) - BACKUP SUCCESS: $SOURCE_DIR -> $BACKUP_FILE" >> "$LOG_FILE"

# Keep only last 5 backups
cd ../backups

BACKUP_COUNT=$(ls -1 backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt 5 ]; then
	    ls -1t backup_*.tar.gz | tail -n +6 | xargs -r rm --
	        echo "$(date) - OLD BACKUPS CLEANED (kept latest 5)" >> "$LOG_FILE"
fi

echo "Backup process completed."
