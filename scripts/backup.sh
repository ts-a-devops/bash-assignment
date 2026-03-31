#!/bin/bash

mkdir -p backups
mkdir -p logs
LOG_FILE="logs/backup.log"

DIR=$1

if [ -z "$DIR" ]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Error: Directory $DIR does not exist"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR"

echo "$(date): Created backup $BACKUP_FILE of $DIR" | tee -a "$LOG_FILE"

# Keep only last 5 backups
BACKUPS_COUNT=$(ls backups/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUPS_COUNT" -gt 5 ]; then
    ls -1t backups/backup_*.tar.gz | tail -n +6 | xargs rm -f
    echo "$(date): Deleted old backups to keep last 5" | tee -a "$LOG_FILE"
fi
