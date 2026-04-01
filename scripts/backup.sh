#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="../logs"
BACKUP_DIR="../backups"
mkdir -p "$LOG_DIR" "$BACKUP_DIR"

LOG_FILE="$LOG_DIR/backup.log"

DIR=${1:-}

[[ -z "$DIR" || ! -d "$DIR" ]] && echo "Invalid directory" && exit 1

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR"

echo "$(date): Backup created $BACKUP_FILE" >> "$LOG_FILE"

ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm --
