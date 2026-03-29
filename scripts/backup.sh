#!/bin/bash

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"

dir=$1

# Validate input
if [[ -z "$dir" ]]; then
	    echo "Error: Please provide a directory to backup" | tee -a "$LOG_FILE"
	        exit 1
fi

if [[ ! -d "$dir" ]]; then
	    echo "Error: Directory does not exist" | tee -a "$LOG_FILE"
	        exit 1
fi

# Create backup name
timestamp=$(date +%F_%H-%M-%S)
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file" | tee -a "$LOG_FILE"

# Keep only last 5 backups
cd "$BACKUP_DIR" || exit
ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f
cd - > /dev/null

echo "Old backups cleaned (kept last 5)" | tee -a "$LOG_FILE"
