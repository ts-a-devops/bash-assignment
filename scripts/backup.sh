#!/usr/bin/env bash

BACKUP_DIR="../backups"
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

SOURCE_DIR=$1

if [[ -z "$SOURCE_DIR" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup created: $BACKUP_FILE"
echo "$(date): Backup of $SOURCE_DIR created" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs -r rm --

echo "Old backups cleaned."
