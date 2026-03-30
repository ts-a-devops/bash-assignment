#!/bin/bash

# Create required folders
mkdir -p backups logs

LOG_FILE="logs/backup.log"

# Get directory from user
DIR=$1

# Validate input
if [[ -z "$DIR" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [[ ! -d "$DIR" ]]; then
    echo "Error: Directory does not exist"
    exit 1
fi

# Timestamp
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

BACKUP_FILE="backups/backup_$DATE.tar.gz"

# Create backup
tar -czf $BACKUP_FILE $DIR

echo "$(date): Backup created for $DIR -> $BACKUP_FILE" >> $LOG_FILE

echo "Backup successful: $BACKUP_FILE"

# Keep only last 5 backups
ls -t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "$(date): Old backups cleaned" >> $LOG_FILE

