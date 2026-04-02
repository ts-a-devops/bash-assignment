#!/bin/bash

SOURCE_DIR=$1
BACKUP_DIR="../backups"
LOG_FILE="../logs/backup.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR" "$(dirname "$LOG_FILE")"

# Logging function
log() {
  echo -e "$1" | tee -a "$LOG_FILE"
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

# Create timestamp
#TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
TIMESTAMP=$(date +"%Y%m%d_%H:%M:%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create backup safely
if tar -czf "$BACKUP_FILE" "$SOURCE_DIR"; then
  log "Backup created: $BACKUP_FILE"
else
  log "Backup failed!"
  exit 1
fi

# Cleanup old backups (keep last 5 safely)
log "Cleaning old backups..."
find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -printf "%T@ %p\n" \
  | sort -nr \
  | tail -n +6 \
  | cut -d' ' -f2- \
  | xargs -r rm --

log "Old backups cleaned"
