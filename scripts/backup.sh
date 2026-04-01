#!/bin/bash
set -euo pipefail

SOURCE_DIR=${1:-}
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"

if [[ -z "$SOURCE_DIR" || ! -d "$SOURCE_DIR" ]]; then
  echo "Invalid directory."
  exit 1
fi

TIMESTAMP=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "$(date): Backup created -> $BACKUP_FILE" >> "$LOG_FILE"

# Keep only last 5 backups
ls -t $BACKUP_DIR | tail -n +6 | while read file; do
  rm "$BACKUP_DIR/$file"
done
