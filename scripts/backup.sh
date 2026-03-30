#!/bin/bash
mkdir -p backups
dir_to_backup=$1

if [ ! -d "$dir_to_backup" ]; then
    echo "Error: Directory '$dir_to_backup' does not exist."
    exit 1
fi

timestamp=$(date +%Y%m%d%H%M%S)
backup_file="backups/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" "$dir_to_backup"
echo "Backup successfully created: $backup_file"

# Keep only the last 5 backups
ls -1tr backups/backup_*.tar.gz 2>/dev/null | head -n -5 | xargs -r rm -f
echo "Old backups cleaned up. Kept the most recent 5."
