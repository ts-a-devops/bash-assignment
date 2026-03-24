#!/bin/bash

# Create directories
mkdir -p backups logs

log_file="logs/backup.log"

# Input directory
dir=$1

# Validate input
if [[ -z "$dir" ]]; then
    echo "Error: Please provide a directory to back up."
    exit 1
fi

if [[ ! -d "$dir" ]]; then
    echo "Error: Directory '$dir' does not exist."
    exit 1
fi

# Create backup filename
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_file="backups/backup_$timestamp.tar.gz"

# Create compressed backup
tar -czf "$backup_file" "$dir"

if [[ $? -eq 0 ]]; then
    echo "Backup created successfully: $backup_file"
    echo "$(date): Backup created for $dir → $backup_file" >> "$log_file"
else
    echo "Error creating backup."
    echo "$(date): FAILED backup for $dir" >> "$log_file"
    exit 1
fi

# Keep only last 5 backups
echo "Cleaning old backups..."

ls -t backups/backup_*.tar.gz | tail -n +6 | while read old_backup; do
    rm -f "$old_backup"
    echo "$(date): Deleted old backup $old_backup" >> "$log_file"
done

echo "Backup process completed."
