#!/bin/bash


set -euo pipefail

# Ensure logs and backups directories exist
mkdir -p logs backups

LOG_FILE="logs/backup.log"

# Logging function
log_action() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

#Check input argument
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <directory>"
    log_action "BACKUP - FAILED - No directory provided"
    exit 1
fi

SOURCE_DIR="$1"

#Validating if directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory does not exist."
    log_action "BACKUP $SOURCE_DIR - FAILED - Directory not found"
    exit 1
fi

#Generating timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"

#Creating compressed backup
if tar -czf "$BACKUP_FILE" "$SOURCE_DIR"; then
    echo "Backup created: $BACKUP_FILE"
    log_action "BACKUP $SOURCE_DIR → $BACKUP_FILE - SUCCESS"
else
    echo "Backup failed."
    log_action "BACKUP $SOURCE_DIR - FAILED - tar error"
    exit 1
fi


BACKUP_COUNT=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ "$BACKUP_COUNT" -gt 5 ]]; then
    ls -1t backups/backup_*.tar.gz | tail -n +6 | while read -r old_file; do
        rm -f "$old_file"
        log_action "DELETE OLD BACKUP $old_file - SUCCESS"
    done
fi

echo "Backup process completed."

