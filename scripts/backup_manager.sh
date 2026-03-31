#!/bin/bash
# scripts/backup_manager.sh

# Ensure backups directory exists
mkdir -p backups
mkdir -p logs

# Log file
LOG_FILE="logs/backup_manager.log"

# Function to log messages with timestamp
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check for input argument
SOURCE_DIR=$1
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

# Validate directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    log_action "BACKUP FAILED: Directory '$SOURCE_DIR' does not exist"
    exit 1
fi

# Create backup filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"

# Create compressed backup
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .
if [[ $? -eq 0 ]]; then
    echo "Backup created: $BACKUP_FILE"
    log_action "BACKUP SUCCESS: $BACKUP_FILE from $SOURCE_DIR"
else
    echo "Backup failed for $SOURCE_DIR"
    log_action "BACKUP FAILED: $SOURCE_DIR"
    exit 1
fi

# Keep only the last 5 backups
BACKUP_COUNT=$(ls backups/backup_*.tar.gz 2>/dev/null | wc -l)
if [[ $BACKUP_COUNT -gt 5 ]]; then
    # Delete oldest backups
    ls -1t backups/backup_*.tar.gz | tail -n +6 | while read OLD_BACKUP; do
        rm "$OLD_BACKUP"
        log_action "OLD BACKUP DELETED: $OLD_BACKUP"
    done
fi
