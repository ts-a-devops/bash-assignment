#!/bin/bash
set -euo pipefail

mkdir -p logs backups

LOG_FILE="logs/backup.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Validate input
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

SOURCE_DIR=$1

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist"
    log "FAILED: Backup '$SOURCE_DIR' - directory not found"
    exit 1
fi

# Create backup
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="backups/$BACKUP_NAME"

log "Starting backup of '$SOURCE_DIR'..."

tar -czf "$BACKUP_PATH" "$SOURCE_DIR"

log "Backup created: $BACKUP_PATH"

# Keep only last 5 backups
cd backups
ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | while read -r old_backup; do
    rm "$old_backup"
    log "Removed old backup: $old_backup"
done
cd ..

log "Backup complete. Total backups: $(ls backups/backup_*.tar.gz 2>/dev/null | wc -l)"
