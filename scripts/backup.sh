#!/bin/bash



LOG_FILE="logs/backup.log"

input_dir=$1

# Validate input
if [[ -z "$input_dir" ]]; then
    echo "Error: Please provide a directory."
    exit 1
fi

if [[ ! -d "$input_dir" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Create backup
timestamp=$(date +%Y%m%d%H%M%S)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$input_dir"

echo "Backup successful: $backup_file"
echo "$(date): Backup created -> $backup_file" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t backups/*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm --
