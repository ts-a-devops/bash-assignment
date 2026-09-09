#!/usr/bin/env bash

# Paths setup
BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$BASE_DIR/backups"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log_msg() {
    local msg="$1"
    echo "$msg"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" >> "$LOG_FILE"
}

TARGET_DIR="$1"

# 1. Check if argument was provided
if [ -z "$TARGET_DIR" ]; then
    log_msg "Error: No target directory provided."
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

# 2. Validate that target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    log_msg "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

# 3. Create compressed archive
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

log_msg "Starting backup of '$TARGET_DIR'..."
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$TARGET_DIR")" "$(basename "$TARGET_DIR")" 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    log_msg "Success: Backup created at '$ARCHIVE_PATH'."
else
    log_msg "Error: Failed to create archive for '$TARGET_DIR'."
    exit 1
fi

# 4. Retention policy: Keep only the 5 most recent backups
cd "$BACKUP_DIR" || exit 1
BACKUP_COUNT=$(ls -1t backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt 5 ]; then
    log_msg "Notice: Found $BACKUP_COUNT backups. Pruning to retain only the latest 5..."
    ls -1t backup_*.tar.gz | tail -n +6 | while read -r old_backup; do
        rm -f "$old_backup"
        log_msg "Pruned old backup: $old_backup"
    done
fi

log_msg "Backup process completed successfully."
