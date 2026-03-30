#!/bin/bash

# Create folders
mkdir backups 2>/dev/null
mkdir logs 2>/dev/null

LOG_FILE="logs/backup.log"

# Get directory from user
dir=$1

# Check if directory is provided
if [ -z "$dir" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Check if directory exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Create timestamp
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Create backup filename
backup_file="backups/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): Backup created for $dir -> $backup_file" >> "$LOG_FILE"

# Keep only last 5 backups
echo "Cleaning old backups..."

ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read old_file
do
    rm "$old_file"
    echo "$(date): Deleted old backup $old_file" >> "$LOG_FILE"
done

echo "Done."