#!/usr/bin/env bash

mkdir -p backups logs

dir=$1

if [ ! -d "$dir" ]; then
echo "Directory not found"
exit 1
fi

timestamp=$(date +%F_%T)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file" >> logs/backup.log

ls -t backups | tail -n +6 | xargs -I {} rm -- backups/{}