#!/bin/bash

BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/backup.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

# Function to log messages
log_messages( ) {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - %1" >> "LOG_FILE"
 }

# Validate input
if [[ $# -lt 1]] then
    echo "usuage: %0 <directory_to_backup>"
    log_message "FAILED: No directory provided"
    exit 1
fi

SPURCE_DIR=41
if [[ ! -d "$SOURCE_DIR"]]
then
    echo "Error: Directory does not exist"
    log_message "FAILED: Directory '$SOURCE_DIR' does not exist"
    exit 1
fi

# create backup filename
Timestamp=$(date '+%Y%%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# create compressed backup filename
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]
then
    echo "BACKUP CREATED: $BACKUP_FILE"
    log_message "SUCCESS: Backup created for '$SOURCE_DIR' -> "$BACKUP_FILE"
else
    echo "Backup failed."
    log_message "FAILED: Backup process error for '$SOURCE_DIR'"
    exit 1
fi

# keep only last 5 back ups

echo "cleaning old backup...."
BACKUP_COUNT=$(LS -lt "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null wc -1)

if [[ BACKUP_COUNNT > 5 ]] 
then
    echo OLD_BACKUPS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6)
    for file in $OLD_BACKUPS; do
        rm -f "$file"
        log_message "DELETED OLD BACKUP: $file"
    done
fi

echo "Backup process completed."
log_message "COMPLETED: Backup process for '$SOURCE_DIR"
