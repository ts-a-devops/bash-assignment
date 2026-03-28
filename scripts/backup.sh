#!/bin/bash
# backup.sh - Create compressed backup of a directory and rotate old backups

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory_to_backup>" >&2
    exit 1
fi

DIR=$1
BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/backup.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

if [[ ! -d "$DIR" ]]; then
    echo "Error: Directory '$DIR' does not exist or is not a directory." >&2
    exit 1
fi

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

echo "Creating backup of '$DIR' ..."
if tar -czf "$BACKUP_FILE" -C "$(dirname "$DIR")" "$(basename "$DIR")"; then
    echo "Backup created successfully: $BACKUP_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created: $BACKUP_FILE (source: $DIR)" >> "$LOG_FILE"
else
    echo "Error: Backup failed." >&2
    exit 1
fi

# Keep only the last 5 backups (newest first)
echo "Rotating backups (keeping last 5)..."
cd "$BACKUP_DIR" || exit 1
ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -I {} rm -- "{}" 2>/dev/null || true

echo "Backup process completed."
