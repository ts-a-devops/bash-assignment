#!/bin/bash

# Ensure directories exist
mkdir -p backups logs

log_file="logs/backup.log"

# Get input directory
dir=$1

# Validate input
if [[ -z "$dir" ]]; then
  echo "Error: No directory provided"
  exit 1
fi

if [[ ! -d "$dir" ]]; then
  echo "Error: Directory does not exist"
  exit 1
fi

# Create timestamp
timestamp=$(date +%Y%m%d_%H%M%S)

# Backup filename
backup_file="backups/backup_${timestamp}.tar.gz"

# Create backup
tar -czf "$backup_file" "$dir"

if [[ $? -eq 0 ]]; then
  echo "Backup created: $backup_file"
  echo "$(date): Backup created for $dir → $backup_file" >> "$log_file"
else
  echo "Backup failed"
  echo "$(date): Backup failed for $dir" >> "$log_file"
  exit 1
fi

# Keep only last 5 backups
cd backups || exit

ls -t | tail -n +6 | xargs -r rm --

cd - > /dev/null

echo "Old backups cleaned up (kept last 5)"
