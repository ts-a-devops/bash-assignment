#!/bin/bash

backup_dir="backups"
source_dir="/path/to/directory/to/backup"
max_backups=5
log_file="$backup_dir/backup.log"

# Create backup directory
[ ! -d "$backup_dir" ] && mkdir -p "$backup_dir"

# Create backup
timestamp=$(date +"%Y%m%d_%H%M%S")
backup_file="$backup_dir/backup_$timestamp.tar.gz"

echo "$(date): Starting backup" >> "$log_file"

if tar -czf "$backup_file" "$source_dir" 2>/dev/null; then
    echo "$(date): SUCCESS - Created $backup_file" >> "$log_file"
    echo "✓ Backup created: $backup_file"
else
    echo "$(date): ERROR - Backup failed" >> "$log_file"
    echo "✗ Backup failed!"
    exit 1
fi

# Keep only last 5 backups
cd "$backup_dir" || exit
ls -1 backup_*.tar.gz 2>/dev/null | head -n -$max_backups | xargs -r rm -f
cd - > /dev/null || exit

echo "$(date): Backup completed" >> "$log_file"
echo "✓ Done. Log: $log_file"