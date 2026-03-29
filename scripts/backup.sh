#!/bin/bash

mkdir -p backups
mkdir -p logs

LOG_FILE="logs/backup.log"

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>" | tee -a $LOG_FILE
    exit 1
fi

SOURCE=$1

# Validate directory
if [ ! -d "$SOURCE" ]; then
    echo "Error: $SOURCE is not a valid directory" | tee -a $LOG_FILE
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

BACKUP_NAME="backups/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_NAME" "$SOURCE"

echo "Backup created: $BACKUP_NAME" | tee -a $LOG_FILE

# Keep only last 5 backups
ls -t backups/*.tar.gz | tail -n +6 | xargs -r rm --
