#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_ROOT/backups"
LOG_FILE="$PROJECT_ROOT/logs/backup.log"

dir=$1

if [[ ! -d "$dir" ]]; then
    echo "Directory does not exist!"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$dir"

echo "Backup created: $backup_file"
echo "$(date): Backup created for $dir" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t "$BACKUP_DIR" | tail -n +6 | while read file; do
    rm "$BACKUP_DIR/$file"
done
