#!/bin/bash

# Directories
BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/backup.log"

# Create required directories if they don't exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a directory to back up."
    log_action "BACKUP failed - No directory provided"
    exit 1
fi

SOURCE_DIR="$1"

# Validate directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    log_action "BACKUP failed - Directory '$SOURCE_DIR' not found"
    exit 1
fi

# Generate timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

# Backup file name
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create compressed backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_FILE"
    log_action "Backup successful - $BACKUP_FILE"
else
    echo "Error: Backup failed."
    log_action "BACKUP failed during compression"
    exit 1
fi

# Keep only last 5 backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt 5 ]; then
    REMOVE_COUNT=$(($BACKUP_COUNT - 5))
    
    OLD_BACKUPS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n "$REMOVE_COUNT")
    
    for file in $OLD_BACKUPS; do
        rm -f "$file"
        log_action "Deleted old backup - $file"
    done
fi

exit 0
