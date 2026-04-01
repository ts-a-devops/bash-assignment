#!/bin/bash

BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

mkdir -p "$BACKUP_DIR"
mkdir -p logs

log_action() {
    echo "$(date): $1" >> "$LOG_FILE"
}

DIR_TO_BACKUP=$1

if [ -z "$DIR_TO_BACKUP" ]; then
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

if [ ! -d "$DIR_TO_BACKUP" ]; then
    echo "Error: Directory does not exist"
    log_action "Failed backup: $DIR_TO_BACKUP (not found)"
    exit 1
fi

TIMESTAMP=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# create backup
tar -czf "$BACKUP_FILE" "$DIR_TO_BACKUP"

echo "Backup created: $BACKUP_FILE"
log_action "Created backup for $DIR_TO_BACKUP -> $BACKUP_FILE"

# keep only last 5 backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR" | wc -l)

if [ "$BACKUP_COUNT" -gt 5 ]; then
    ls -t "$BACKUP_DIR" | tail -n +6 | while read old_backup; do
        rm -f "$BACKUP_DIR/$old_backup"
        log_action "Deleted old backup: $old_backup"
    done
fi
