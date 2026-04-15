#!/bin/bash

LOG_FILE="../logs/backup.log"
BACKUP_DIR="../backups"

input_dir=$1

# Validate directory
if [[ ! -d "$input_dir" ]]; then
    echo "Directory does not exist!"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$input_dir"

echo "Backup created: $backup_file"

# Keep only last 5 backups
ls -t $BACKUP_DIR | tail -n +6 | while read file; do
    rm "$BACKUP_DIR/$file"
done

# Log
echo "$(date): Backup created for $input_dir" >> "$LOG_FILE"
