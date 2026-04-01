#!/bin/bash

# 1. Configuration
SOURCE_DIR=$1
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"
mkdir -p "logs"

# 2. Validation
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

# 3. Create Compressed Backup
echo "Starting backup of $SOURCE_DIR..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR" 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "$(date): Successfully created $BACKUP_NAME" >> "$LOG_FILE"
    echo "Backup completed: $BACKUP_DIR/$BACKUP_NAME"
else
    echo "$(date): Failed to create backup" >> "$LOG_FILE"
    exit 1
fi

# 4. Retention Policy (Keep only last 5)
# ls -t sorts by modification time (newest first)
# tail -n +6 selects everything starting from the 6th line (the older ones)
old_backups=$(ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6)

if [ -n "$old_backups" ]; then
    echo "Cleaning up old backups..."
    for file in $old_backups; do
        rm "$file"
        echo "$(date): Deleted old backup $file" >> "$LOG_FILE"
    done
fi
