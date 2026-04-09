#!/bin/bash
# Accept a directory as input

SOURCE_DIR=$1
BACKUP_DIR="backups"
LOG_FILE="backup.log"
mkdir -p "$BACKUP_DIR"

# Validate that the directory exists
if [[ -z "$SOURCE_DIR" ]] ; then
    echo "No directory provided." | tee -a "$LOG_FILE"
    exit 1
elif [[ ! -d "$SOURCE_DIR" ]] ; then
    echo "Error: '$SOURCE_DIR' is not a valid directory."
    exit 1
fi
# Create and store compressed backup
timestamp=$(date +"%Y%m%d_%H%M%S") 
BACKUP_FILE="backups/backup_$timestamp.tar.gz" 
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"
echo "$(date) - Backup created: $BACKUP_FILE" | tee -a "$LOG_FILE"

# Keep only the last 5 backups (delete older ones)
ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 |
while read file; do
    rm "$file"
    echo "$(date) - Deleted old backup: $file" | tee -a "$LOG_FILE"
done
