#!/bin/bash

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"

mkdir -p $BACKUP_DIR logs

TARGET_DIR=$1

if [[ -z "$TARGET_DIR" ]]; then
  echo "Please provide a directory to backup."
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Directory does not exist."
  exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$TARGET_DIR"

echo "$(date) - Backup created: $BACKUP_FILE" >> $LOG_FILE

# Keep only last 5 backups
ls -t $BACKUP_DIR | tail -n +6 | while read file; do
  rm "$BACKUP_DIR/$file"
  echo "$(date) - Deleted old backup: $file" >> $LOG_FILE
done
