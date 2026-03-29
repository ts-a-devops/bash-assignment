#!/bin/bash

mkdir -p backups logs
LOG_FILE="logs/backup.log"

dir=$1

if [[ ! -d $dir ]]; then
    echo "Invalid directory"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf $backup_file $dir

echo "Backup created: $backup_file"
echo "$(date): $backup_file" >> $LOG_FILE

ls -t backups/*.tar.gz | tail -n +6 | xargs rm -f
