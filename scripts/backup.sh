#!/bin/bash

dir=$1
timestamp=$(date +%F_%H-%M-%S)
backup_dir="../backups"
log_file="../logs/backup.log"

# Check if directory exists
if [ ! -d "$dir" ]; then
  echo "Error: Directory does not exist."
  exit 1
fi

# Create backup
backup_file="$backup_dir/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): Backed up $dir to $backup_file" >> "$log_file"

# Keep only last 5 backups
cd "$backup_dir" || exit

ls -t | tail -n +6 | xargs -I {} rm -- {}

echo "Old backups cleaned up (keeping last 5)" >> "$log_file"
