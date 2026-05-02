#!/bin/bash

# Backup management

set -euo pipefail

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"
MAX_BACKUPS=5

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$BACKUP_DIR"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

show_usage() {
    echo "Usage: $0 <directory_to_backup>"
    echo ""
    echo "Example:"
    echo "  $0 /home/user/documents"
    echo ""
    echo "Options:"
    echo "  Backups are stored in: $BACKUP_DIR/"
    echo "  Latest 5 backups are kept, older ones are deleted"
    echo ""
}

# Check if directory argument is provided
if [[ $# -lt 1 ]]; then
    echo "Error: No directory specified"
    show_usage
    exit 1
fi

SOURCE_DIR="$1"

# Validate directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    log_message "ERROR: Directory does not exist: $SOURCE_DIR"
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

log_message "=== Backup Process Started ==="
log_message "Source Directory: $SOURCE_DIR"

# Create backup with timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILENAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILENAME}"


DIR_NAME=$(basename "$SOURCE_DIR")

echo "Creating backup of: $SOURCE_DIR"
echo "Backup file: $BACKUP_FILENAME"

# Create the compressed backup
if tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
    BACKUP_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
    log_message "SUCCESS: Backup created - $BACKUP_FILENAME ($BACKUP_SIZE)"
    echo "✓ Backup created successfully: $BACKUP_FILENAME ($BACKUP_SIZE)"
else
    log_message "ERROR: Failed to create backup"
    echo "Error: Failed to create backup"
    exit 1
fi

log_message "--- Backup Rotation ---"


BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
log_message "Total backups available: $BACKUP_COUNT"

if [[ $BACKUP_COUNT -gt $MAX_BACKUPS ]]; then
    echo "Rotating backups (keeping last $MAX_BACKUPS)..."
    
    # Remove oldest backups
    ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n "+$((MAX_BACKUPS + 1))" | while read -r old_backup; do
        log_message "DELETED (rotation): $(basename "$old_backup")"
        rm -f "$old_backup"
        echo "  Removed: $(basename "$old_backup")"
    done
fi

log_message "--- Current Backups ---"
echo ""
echo "Current backups in $BACKUP_DIR:"
ls -lh "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'

log_message "=== Backup Process Completed ==="

exit 0
