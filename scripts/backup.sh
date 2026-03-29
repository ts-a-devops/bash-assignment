#!/bin/bash

# Check if directory argument is provided
if [ -z "$1" ]; then
	echo "Usage: $0 <directory>"
	exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

# Validate directory exists
if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Directory does not exist"
	exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create backup file
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# Log activity
echo "$(date): Backup created -> $BACKUP_FILE" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t $BACKUP_DIR/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "Backup completed successfully"
