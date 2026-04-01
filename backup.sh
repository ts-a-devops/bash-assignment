#!/bin/bash

# This script creates a compressed backup of a given directory

LOG_FILE="logs/backup.log"
BACKUP_DIR="backups"
SOURCE_DIR=$1  # The directory the user wants to back up

# ─── VALIDATE INPUT ───────────────────────────────────────────
# Check if the user provided a directory
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: Please provide a directory to back up."
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

# Check if the provided directory actually exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: '$SOURCE_DIR' does not exist or is not a directory."
    exit 1
fi

# ─── CREATE BACKUPS FOLDER ────────────────────────────────────
# Create the backups directory if it does not already exist
mkdir -p "$BACKUP_DIR"

# ─── CREATE COMPRESSED BACKUP ─────────────────────────────────
# Build the backup filename using the current timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

echo "Backing up '$SOURCE_DIR'..."

# tar flags:
# -c = create a new archive
# -z = compress it using gzip (produces .tar.gz)
# -f = specify the output filename
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup created: $BACKUP_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created: $BACKUP_FILE" >> "$LOG_FILE"

# ─── KEEP ONLY THE LAST 5 BACKUPS ─────────────────────────────
# List all backups sorted by oldest first, count how many exist
# If there are more than 5, delete the oldest ones

BACKUP_COUNT=$(ls "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ "$BACKUP_COUNT" -gt 5 ]]; then

    # Calculate how many backups need to be deleted
    DELETE_COUNT=$((BACKUP_COUNT - 5))

    echo "More than 5 backups found. Removing $DELETE_COUNT oldest backup(s)..."

    # ls -t sorts by newest first, so we reverse it with tail to get oldest first
    # then we delete only the number we need to remove
    ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n "$DELETE_COUNT" | while read old_backup; do
        rm "$old_backup"
        echo "Deleted old backup: $old_backup"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Deleted old backup: $old_backup" >> "$LOG_FILE"
    done

fi

# ─── DONE ─────────────────────────────────────────────────────
echo ""
echo "Backup complete. Backups stored in: $BACKUP_DIR"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup process finished." >> "$LOG_FILE"
