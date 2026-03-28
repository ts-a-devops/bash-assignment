#!/bin/bash

# Create backups and logs directory if they don't exist
mkdir -p backups
mkdir -p logs

# Check if a directory was provided
if [ -z "$1" ]; then
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

directory=$1

# Validate that the directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory $directory does not exist!"
    exit 1
fi

# Create a timestamp
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Create compressed backup
backup_file="backups/backup_$timestamp.tar.gz"
tar -czf "$backup_file" "$directory"
echo "Backup created: $backup_file"

# Log backup activity
echo "Backup of $directory created at $timestamp" >> logs/backup.log

# Keep only the last 5 backups
backup_count=$(ls backups/ | wc -l)
if [ "$backup_count" -gt 5 ]; then
    oldest_backup=$(ls backups/ | head -1)
    rm "backups/$oldest_backup"
    echo "Old backup deleted: $oldest_backup"
fi

echo "Backup completed successfully!"
