#!/bin/bash
# --------------------------------------------------------------------------
# Script: backup.sh
# Description: Accepts a directory as input. Creates a timestamped `.tar.gz`.
#              Stores in backups/ and keeps only the last 5 backups.
# --------------------------------------------------------------------------

# Set the backups folder and make sure it exists
BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"

# Also log this activity
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ensure the user provides a target directory parameter
TARGET_SOURCE="$1"
if [ -z "$TARGET_SOURCE" ]; then
    echo "Usage: ./backup.sh <directory-to-backup>"
    log_action "[ERROR] Backup attempted with no directory parameter."
    exit 1
fi

# Ensure that the directory requested actually exists!
if [ ! -d "$TARGET_SOURCE" ]; then
    echo "Error: The directory '$TARGET_SOURCE' does not exist!"
    log_action "[ERROR] Backup failed. Directory '$TARGET_SOURCE' does not exist."
    exit 1
fi

echo "=== System Backup Script ==="

# Generate timestamp (YYYYMMDD_HHMMSS)
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
BACKUP_FILENAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILENAME}"

echo "Starting compression of '$TARGET_SOURCE'..."

# Create compressed backup
# The 'tar' command groups files and compresses them utilizing gzip
# -c: Create an archive
# -z: Compress with gzip tool
# -f: Create archive with the filename that follows
if tar -czf "$BACKUP_PATH" "$TARGET_SOURCE" 2>/dev/null; then
    echo "✅ Backup successfully created at: $BACKUP_PATH"
    log_action "[SUCCESS] Created backup archive '$BACKUP_PATH' for '$TARGET_SOURCE'."
else
    echo "❌ Backup Failed."
    log_action "[ERROR] Tar command failed while backing up '$TARGET_SOURCE'."
    exit 1
fi

# Cleanup old backups
# We only want to keep the 5 most recent files.
echo "Cleaning up older backups (keeping only the last 5)!"

# Drop into the backups directory temporarily
cd "$BACKUP_DIR" || exit

# `ls -t` sorts files by modified time (newest first).
# `tail -n +6` outputs starting from the 6th file list.
# `while read -r old_file` safely loops each line to 'rm -f'
ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | while read -r old_file; do
    echo "Deleting old backup: $old_file"
    rm -f "$old_file"
    log_action "[INFO] Deleted old backup file '$old_file'."
done

echo "Backup process finished."
