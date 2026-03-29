#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../logs/backup.log"
BACKUP_DIR="$SCRIPT_DIR/../backups"

dir=$1

if [[ -z "$dir" ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [[ ! -d "$dir" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

timestamp=$(date +%F_%H-%M-%S)
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

mkdir -p "$BACKUP_DIR"

tar -czf "$backup_file" "$dir"

echo "$(date): Backup created -> $backup_file" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t $BACKUP_DIR/backup_*.tar.gz | tail -n +6 | xargs -r rm --

echo "Old backups cleaned up" >> "$LOG_FILE"
