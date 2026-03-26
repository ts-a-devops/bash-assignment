#!/bin/bash

set -euo pipefail

# Create required directories
mkdir -p logs backups

LOGFILE="logs/backup.log"

# Function to log actions
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
}

usage() {
    cat << EOF
Usage: $0 <directory_to_backup>

Example:
  ./backup.sh /home/user/documents
  ./backup.sh scripts
EOF
}

# Check if directory argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Directory path is required."
    usage
    exit 1
fi

SOURCE_DIR="$1"

# Validate that the directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    log_action "BACKUP FAILED - Directory not found: $SOURCE_DIR"
    exit 1
fi

# Create timestamp for backup file
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"

echo "Starting backup of directory: $SOURCE_DIR"
echo "Backup will be saved as: $BACKUP_FILE"

# Create the compressed backup
if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
    echo "Success: Backup created successfully."
    log_action "BACKUP SUCCESS - Created: $BACKUP_FILE | Source: $SOURCE_DIR"
else
    echo "Error: Failed to create backup."
    log_action "BACKUP FAILED - tar command failed for source: $SOURCE_DIR"
    exit 1
fi

# Keep only the last 5 backups (delete older ones)
cd backups || exit 1
if ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm --; then
    echo "Old backups cleaned up (keeping only latest 5)."
    log_action "BACKUP CLEANUP - Kept only the 5 most recent backups"
else
    echo "No old backups to clean up."
fi
cd - > /dev/null

echo ""
echo "Backup completed. Log saved to: $LOGFILE"
