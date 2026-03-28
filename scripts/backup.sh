#!/bin/bash

# Create backups and logs directory if they don't exist
mkdir -p backups
mkdir -p logs

# Check if directory was provided
if [ -z "$1" ]; then
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

directory=$1

# Validate directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory does not exist!"
    exit 1
fi

# Create timestamp
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Backup file name
backup_file="backups/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$directory"

echo "Backup created: $backup_file"

# Log activity
echo "$(date): Backup created for $directory -> $backup_file" >> logs/backup.log

# Keep only last 5 backups
ls -t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm --

echo "Old backups cleaned up"

echo "Backup completed successfully!"
