#!/bin/bash

# Create required folders
mkdir -p ../backups ../logs

# Ask user for directory
read -p "Enter directory to backup: " dir

# Check if directory exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory does not exist!"
    exit 1
fi

# Create timestamp
timestamp=$(date +%F_%H-%M-%S)

# Define backup file
backup_file="../backups/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$dir"

# Confirm success
echo "Backup created: $backup_file"
echo "Backup created: $backup_file" >> ../logs/backup.log

# Keep only last 5 backups
ls -t ../backups/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "Old backups cleaned" >> ../logs/backup.log
