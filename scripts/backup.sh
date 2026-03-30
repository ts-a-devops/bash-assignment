#!/bin/bash

set -e

SOURCE_DIR="$1"
BACKUP_DIR="../backups"
LOG_FILE="../logs/backup.log"

# Function for logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Validate input
if [[ -z "$SOURCE_DIR" ]]; then
    log "Error: No source directory provided"
    log "Usage: $0 <source_directory>"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    log "Error: Directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Ensure backup and log directories exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Create backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

if tar -czf "$BACKUP_FILE" "$SOURCE_DIR"; then
    log "Backup successfully created: $BACKUP_FILE"
else
    log "Error: Backup failed"
    exit 1
fi

# Cleanup old backups (keep only latest 5)
BACKUPS=($(ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null))

if (( ${#BACKUPS[@]} > 5 )); then
    for ((i=5; i<${#BACKUPS[@]}; i++)); do
        rm -f "${BACKUPS[$i]}"
        log "Deleted old backup: ${BACKUPS[$i]}"
    done
fi

log "Backup process completed"
