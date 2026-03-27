#!/bin/bash

# 1. Setup Environment
SOURCE_DIR=$1
BACKUP_DIR="backups"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="logs/backup.log"

# Ensure directories exist
[ ! -d "$BACKUP_DIR" ] && mkdir "$BACKUP_DIR"
[ ! -d "logs" ] && mkdir "logs"

# Function to log activity
log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 2. Validation
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: ./backup.sh <directory_to_backup>"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    log_msg "FAILED: Directory '$SOURCE_DIR' not found."
    exit 1
fi

# 3. Create Compressed Backup
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
echo "Starting backup of $SOURCE_DIR..."

# tar flags: c (create), z (gzip compress), f (file name)
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR" 2>>"$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_NAME"
    log_msg "SUCCESS: Created $BACKUP_NAME"
else
    echo "Backup failed. Check logs."
    log_msg "ERROR: tar command failed for $SOURCE_DIR"
    exit 1
fi

# 4. Retention Policy (Keep only the last 5)
echo "Applying retention policy (keeping last 5 backups)..."

# ls -t: sorts by time (newest first)
# tail -n +6: picks everything starting from the 6th item
OLD_BACKUPS=$(ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6)

if [ -n "$OLD_BACKUPS" ]; then
    for old_file in $OLD_BACKUPS; do
        rm "$old_file"
        log_msg "CLEANUP: Deleted old backup $old_file"
    done
    echo "Old backups cleaned up."
else
    echo "No old backups to delete."
fi

echo "Done."
