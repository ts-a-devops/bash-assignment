#!/bin/bash
# This is the Backup Script

mkdir -p backups logs

if [ $# -ne 1 ]; then
    echo "Usage: ./backup.sh foldername"
    echo "Example: ./backup.sh ."
    exit 1
fi

folder=$1

if [ ! -d "$folder" ]; then
    echo "Error: '$folder' is not a folder!"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_name="backups/backup_${timestamp}.tar.gz"

echo "Creating backup of '$folder' ..."
tar -czf "$backup_name" "$folder"

if [ $? -eq 0 ]; then
    echo "Backup created: $backup_name"
    echo "$(date) - Backup created: $backup_name" >> logs/backup.log
else
    echo "Backup failed!"
    exit 1
fi

# Keep only last 5 backups
cd backups
ls -t *.tar.gz 2>/dev/null | tail -n +6 | xargs rm -- 2>/dev/null || true
cd ..
echo "Old backups cleaned (keeping only last 5)"