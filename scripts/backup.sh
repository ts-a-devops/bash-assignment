#!/bin/bash

BACKUP_DIR="../backups"
LOG_FILE="../logs/backup.log"

read -p "Enter directory to backup: " dir

if [[ ! -d "$dir" ]]; then
  echo "Directory does not exist!"
  exit 1
fi

timestamp=$(date +"%Y%m%d_%H%M%S")
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): Backup created for $dir" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t $BACKUP_DIR/backup_*.tar.gz | tail -n +6 | xargs -r rm --

echo "Old backups cleaned up." >> "$LOG_FILE"
