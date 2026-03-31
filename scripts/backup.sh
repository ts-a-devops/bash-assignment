#!/bin/bash

# backup.sh - Creates compressed backups of directories

# Create logs and backups directories if they don't exist
mkdir -p logs backups

LOG_FILE="logs/backup.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check if directory is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <directory_to_backup>"
    log_message "Error: No directory provided"
    exit 1
fi

BACKUP_DIR="$1"

# Validate directory exists
if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Error: Directory '$BACKUP_DIR' does not exist"
    log_message "Error: Directory not found - $BACKUP_DIR"
    exit 1
fi

# Create backup with timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="backups/${BACKUP_NAME}"

# Create compressed backup
echo "Creating backup of '$BACKUP_DIR'..."
tar -czf "$BACKUP_PATH" -C "$(dirname "$BACKUP_DIR")" "$(basename "$BACKUP_DIR")" 2>/dev/null

if [[ $? -eq 0 ]]; then
    echo "✓ Backup created successfully: $BACKUP_PATH"
    log_message "Backup created: $BACKUP_PATH (Size: $(du -h "$BACKUP_PATH" | cut -f1))"
else
    echo "Error: Failed to create backup"
    log_message "Error: Failed to create backup for $BACKUP_DIR"
    exit 1
fi

# Keep only the last 5 backups (delete older ones)
echo "Cleaning up old backups..."
BACKUP_COUNT=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)

if (( BACKUP_COUNT > 5 )); then
    OLD_BACKUPS=$(ls -1t backups/backup_*.tar.gz 2>/dev/null | tail -n +6)
    while IFS= read -r backup; do
        rm "$backup"
        log_message "Deleted old backup: $backup"
        echo "Deleted old backup: $backup"
    done <<< "$OLD_BACKUPS"
fi

log_message "Backup operation completed successfully"
echo "✓ Backup operation completed"
