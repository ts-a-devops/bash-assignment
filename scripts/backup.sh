#!/bin/bash


# Backup Script: Create compressed backup of a directory
# Simple backup script - keeps last 5 backups
# Usage: ./backup.sh /path/to/directory

set -euo pipefail
# -------------------------- Configuration --------------------------
BACKUP_DIR="../backups"
LOG_FILE="../logs/backup.log"
MAX_BACKUPS=5




# -------------------------- Functions -----------------------------

log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}

# -------------------------- Input Validation ----------------------
if [ $# -eq 0 ]; then
    echo "Error: No directory provided."
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

SOURCE_DIR="$1"

# Validate source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR: Directory '$SOURCE_DIR' does not exist or is not a directory."
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# -------------------------- Create Backup -------------------------

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

log "Starting backup of directory: $SOURCE_DIR"
log "Creating backup: $BACKUP_NAME"


# Create compressed tar.gz backup

if tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
#-C "$(dirname "$DIR")" → Change to the parent directory of the target folder first

    log "Backup completed successfully: $BACKUP_PATH"
    log "Backup size: $(du -h "$BACKUP_PATH" | cut -f1)"
else
    log "ERROR: Failed to create backup."
    rm -f "$BACKUP_PATH"  # Remove partial backup if failed
    exit 1
fi

# -------------------------- Cleanup Old Backups -------------------

log "Cleaning up old backups (keeping last $MAX_BACKUPS)..."

# Count current backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    # Delete oldest backups (keep only the newest MAX_BACKUPS)
    ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -I {} rm -- "{}"
    log "Old backups removed. Kept the latest $MAX_BACKUPS backups."
fi

# -------------------------- Final Summary -------------------------

log "Backup process completed."
log "----------------------------------------"

# Optional: Show current backups
echo "Current backups:"
ls -lh "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n "$MAX_BACKUPS" || echo "No backups found."

exit 0

















