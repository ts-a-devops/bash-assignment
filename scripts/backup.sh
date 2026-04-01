#!/bin/bash

#  Configuration 
BACKUP_DIR="$(dirname "$0")/../backups"
LOG_FILE="$(dirname "$0")/../logs/backup.log"
MAX_BACKUPS=5

#  Logging Function 
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

#  Validate Input 
if [ $# -eq 0 ]; then
    log_message "ERROR: No directory provided"
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

SOURCE_DIR="$1"

if [ ! -d "$SOURCE_DIR" ]; then
    log_message "ERROR: Directory '$SOURCE_DIR' does not exist"
    echo "Error: '$SOURCE_DIR' is not a valid directory"
    exit 1
fi

#   Create backups folder if it doesn't exist 
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

#   Create Backup 
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

log_message "Starting backup of '$SOURCE_DIR'"

tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -eq 0 ]; then
    log_message "SUCCESS: Backup created at '$BACKUP_FILE'"
else
    log_message "ERROR: Backup failed for '$SOURCE_DIR'"
    exit 1
fi

#  Keep Only Last 5 Backups 
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | while read OLD_BACKUP; do
        rm "$OLD_BACKUP"
        log_message "DELETED old backup: '$OLD_BACKUP'"
    done
fi

log_message "Backup process completed. Total backups: $(ls -1 "$BACKUP_DIR"/backup_*.tar.gz | wc -l)"