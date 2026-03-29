#!/bin/bash

mkdir -p backups logs

# Get the directory to backup
DIR=$1

if [ -z "$DIR" ]; then
    echo "Error: No directory provided"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Error: Directory $DIR does not exist"
    exit 1
fi

# Create backup
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_FILE" "$DIR"

echo "$(date): Backup of $DIR created as $BACKUP_FILE" | tee -a logs/backup.log

# Keep only last 5 backups
BACKUPS_TO_KEEP=5
BACKUP_COUNT=$(ls backups/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$BACKUPS_TO_KEEP" ]; then
    OLDEST=$(ls -t backups/backup_*.tar.gz | tail -n +$((BACKUPS_TO_KEEP + 1)))
    for file in $OLDEST; do
        rm "$file"
        echo "$(date): Deleted old backup $file" | tee -a logs/backup.log
    done
fi