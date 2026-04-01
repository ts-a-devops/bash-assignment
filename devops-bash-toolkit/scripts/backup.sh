#!/bin/bash

LOG_FILE="../logs/backup.log"
BACKUP_DIR="../backups"

mkdir -p "$BACKUP_DIR"
mkdir -p ../logs

DIR=$1

if [ -z "$DIR" ]; then
    echo "Please provide a directory!"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist!"
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR"

echo "Backup created: $BACKUP_FILE"
echo "$(date): Backup created for $DIR" >> "$LOG_FILE"

# Keep only last 5 backups
cd "$BACKUP_DIR"
ls -t | tail -n +6 | xargs -r rm --

echo "Old backups cleaned up"
