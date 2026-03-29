#!/bin/bash

# Backup Script
# Accepts a directory as input
# Validates that the directory exists
# Creates a compressed backup: backup_<timestamp>.tar.gz
# Stores backups in backups/ directory
# Keeps only the last 5 backups
# Logs backup activity

set -euo pipefail

# Create directories if they don't exist
mkdir -p logs backups

LOG_FILE="logs/backup.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <directory_to_backup>"
    echo "Example: $0 /path/to/directory"
}

# Main script logic
log_message "========== Backup Process Started =========="

if [[ $# -lt 1 ]]; then
    log_message "ERROR: No directory provided"
    show_usage
    exit 1
fi

TARGET_DIR=$1

# Validate that directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    log_message "ERROR: Directory '$TARGET_DIR' does not exist"
    echo "Error: Directory does not exist!"
    exit 1
fi

# Get absolute path
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)
log_message "Target directory: $TARGET_DIR"

# Create backup filename with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="backups/$BACKUP_NAME"

# Create backup
log_message "Creating backup: $BACKUP_NAME"
if tar -czf "$BACKUP_PATH" -C "$(dirname "$TARGET_DIR")" "$(basename "$TARGET_DIR")" 2>&1 | tee -a "$LOG_FILE"; then
    log_message "SUCCESS: Backup created: $BACKUP_PATH"
    log_message "Backup size: $(du -h "$BACKUP_PATH" | cut -f1)"
    echo "Backup created successfully: $BACKUP_NAME"
else
    log_message "ERROR: Failed to create backup"
    echo "Error: Backup creation failed!"
    exit 1
fi

# Keep only the last 5 backups
log_message "Cleaning up old backups (keeping only last 5)..."
BACKUP_COUNT=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ $BACKUP_COUNT -gt 5 ]]; then
    # Remove oldest backups
    ls -1t backups/backup_*.tar.gz | tail -n +6 | while read -r old_backup; do
        log_message "Deleting old backup: $old_backup"
        rm -f "$old_backup"
    done
    log_message "Cleanup completed. Backups retained: 5"
else
    log_message "Current backup count: $BACKUP_COUNT (no cleanup needed)"
fi

log_message "========== Backup Process Completed ==========")