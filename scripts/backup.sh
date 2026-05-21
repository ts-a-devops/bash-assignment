#!/bin/bash

# Create folders
mkdir -p backups
mkdir -p logs

# Get directory from user
DIR=$1

# Validate input
if [ -z "$DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup file name
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" "$DIR"

echo "Backup created: $BACKUP_FILE"

# Keep only last 5 backups
ls -t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm --

# Log activity
echo "$(date): Backup created for $DIR → $BACKUP_FILE" >> logs/backup.log
