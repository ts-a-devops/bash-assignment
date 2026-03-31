#!/bin/bash

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"

read -p "Enter directory to backup: " dir

if [[ ! -d "$dir" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

timestamp=$(date +%F_%H-%M-%S)
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): Backup created for $dir" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm

echo "$(date): Old backups cleaned" >> "$LOG_FILE"
