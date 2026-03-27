#!/bin/bash
# Task: Accept a directory as an argument
SOURCE_DIR=$1
BACKUP_DIR="../backups"
LOG="../logs/backup.log"

# Validate that a directory was provided
if [ -z "$SOURCE_DIR" ] || [ ! -d "$SOURCE_DIR" ]; then
    echo "Usage: $0 <directory_name>"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

# Create the compressed backup
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"
echo "[$(date)] SUCCESS: Created $BACKUP_NAME for $SOURCE_DIR" >> "$LOG"

# THE RETENTION POLICY: Keep only the 5 most recent backups
# ls -t sorts by time (newest first). tail -n +6 selects everything after the top 5.
ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs rm -f 2>/dev/null

echo "Backup of $SOURCE_DIR completed. Only the 5 most recent backups are kept."
