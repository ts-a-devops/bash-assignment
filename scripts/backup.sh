#!/bin/bash

# Ensure backups and logs folders exist
mkdir -p backups logs

log_file="logs/backup.log"

# Get input directory
dir="$1"

# Validate input
if [ -z "$dir" ]; then
  echo "Please provide a directory to back up."
  exit 1
fi

if [ ! -d "$dir" ]; then
  echo "Directory does not exist."
  exit 1
fi

# Create timestamp
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

backup_file="backups/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): backup created for $dir" >> "$log_file"

# Keep only last 5 backups
ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm --

echo "Old backups cleaned up."
