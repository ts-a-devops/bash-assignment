#!/bin/bash

mkdir -p backups logs
LOG_FILE="logs/backup.log"

DIR=$1

if [[ -z "$DIR" || ! -d "$DIR" ]]; then
    echo "Error: Directory does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR"

echo "Backup created: $BACKUP_FILE" | tee -a "$LOG_FILE"

# Keep only last 5 backups
ls -t backups/*.tar.gz | tail -n +6 | xargs -r rm

echo "Old backups cleaned." | tee -a "$LOG_FILE"
