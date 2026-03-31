#!/bin/bash

# Create required directories

LOG_FILE="../logs/backup.log"
BACKUP_DIR="../backups"

# Get directory from user
dir=$1


# Check if directory exists
if [[ ! -d "$dir" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Create timestamp
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')

# Backup file name
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

# Create compressed backup
tar -czf "$backup_file" "$dir"

# Message
message="Backup created: $backup_file"

# Display and log
echo "$message"
echo "$(date '+%Y-%m-%d %H:%M:%S'): $message" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t $BACKUP_DIR/*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm

echo "Old backups cleaned (keeping last 5)."
