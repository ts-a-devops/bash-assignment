#!/bin/bash
set -euo pipefail

# -------------------------
# Variables
# -------------------------
BACKUP_DIR="backups"
LOG_FILE="backup.log"
TIMESTAMP=$(date +%F_%H-%M-%S)

# -------------------------
# Check input
# -------------------------
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

SOURCE_DIR="$1"

# -------------------------
# Validate directory
# -------------------------
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory does not exist!"
    exit 1
fi

# -------------------------
# Create backup directory
# -------------------------
mkdir -p "$BACKUP_DIR"

# -------------------------
# Create backup
# -------------------------
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "$(date) - Backup created: $BACKUP_FILE" >> "$LOG_FILE"

# -------------------------
# Keep only last 5 backups
# -------------------------
cd "$BACKUP_DIR"

ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | while read -r old_backup; do
    rm -f "$old_backup"
    echo "$(date) - Deleted old backup: $old_backup" >> "../$LOG_FILE"
done

cd - >/dev/null

echo "Backup completed successfully!"
