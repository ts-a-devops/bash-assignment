#!/bin/bash

mkdir -p  backups logs

dir=$1

if [ ! -d "$dir" ]; then
echo "Directory does not exist"
exit 1
fi

timestamp=$(date +%s)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

# keep only last five backups
ls -t backups/ | tail -n +6 | xargs -I {} rm backups/{}

echo "$(date): Backup created: $backup_file" >> logs/backup.log
echo "Backup created"





