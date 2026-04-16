#!/bin/bash

BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

if [[ -z "$1" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

SOURCE_DIR="$1"

# Validate directory existence
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory does not exist -> $SOURCE_DIR"
    log_action "BACKUP FAILED - invalid directory: $SOURCE_DIR"
    exit 1
fi

# Generate timestamp
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BASENAME=$(basename "$SOURCE_DIR")
BACKUP_FILE="backup_${BASENAME}_${TIMESTAMP}.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"

# Create compressed backup
tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$BASENAME"

if [[ $? -eq 0 ]]; then
    echo "Backup created: $BACKUP_PATH"
    log_action "BACKUP SUCCESS - $SOURCE_DIR -> $BACKUP_FILE"
else
    echo "Backup failed for $SOURCE_DIR"
    log_action "BACKUP FAILED - tar error for $SOURCE_DIR"
    exit 1
fi

# Retention policy: keep only last 5 backups
cd "$BACKUP_DIR" || exit

ls -1t backup_*.tar.gz 2>/dev/null | tail -n +6 | while read -r old_backup; do
    rm -f "$old_backup"
    log_action "RETENTION DELETE - removed $old_backup"
done
