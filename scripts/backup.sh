#!/bin/bash

mkdir -p backups logs

DIR=$1

if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
    echo "Invalid directory" | tee -a logs/backup.log
    exit 1
fi

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR"

echo "Backup created: $BACKUP_FILE" | tee -a logs/backup.log

# Keep only last 5 backups
ls -t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "Old backups cleaned" | tee -a logs/backup.log