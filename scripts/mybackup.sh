#!/bin/bash

# backup.sh

# Usage: ./backup.sh /path/to/directory

# Set variables

BACKUP_DIR="backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

LOG_FILE="logs/mybackup.log"

# Ensure log directory exists

mkdir -p "$(dirname "$LOG_FILE")"

mkdir -p "$BACKUP_DIR"

# Check if directory argument is provided

if [ -z "$1" ]; then

    echo "Error: No directory specified."

    echo "$(date +"%Y-%m-%d %H:%M:%S") - No directory specified." >> "$LOG_FILE"

    exit 1

fi

SOURCE_DIR="$1"

# Validate directory exists

if [ ! -d "$SOURCE_DIR" ]; then

    echo "Error: Directory '$SOURCE_DIR' does not exist."

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Failed backup: '$SOURCE_DIR' does not exist." >> "$LOG_FILE"

    exit 1

fi

# Create backup

BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

if [ $? -eq 0 ]; then

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Backup successful: $BACKUP_FILE" | tee -a "$LOG_FILE"

else

    echo "$(date +"%Y-%m-%d %H:%M:%S") - Backup failed for: $SOURCE_DIR" | tee -a "$LOG_FILE"

    exit 1

fi

# Keep only last 5 backups

BACKUPS_TO_KEEP=5

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$BACKUPS_TO_KEEP" ]; then

    # Delete older backups

    OLDER_BACKUPS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +$((BACKUPS_TO_KEEP+1)))

    for old in $OLDER_BACKUPS; do

        rm -f "$old"

        echo "$(date +"%Y-%m-%d %H:%M:%S") - Deleted old backup: $old" >> "$LOG_FILE"

    done

fi

