#!/bin/bash

mkdir -p backups
LOG_FILE="logs/backup.log"

dir=$1

if [ ! -d "$dir" ]; then
    echo "Directory does not exist"
    exit 1
fi

timestamp=$(date +%F_%H-%M-%S)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): Backup created $backup_file" >> $LOG_FILE

# Keep only last 5 backups
ls -t backups/*.tar.gz | tail -n +6 | xargs -r rm
