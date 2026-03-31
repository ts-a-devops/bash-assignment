#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="$(dirname "$0")/../backups"
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$BACKUP_DIR" "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup.log"
MAX_BACKUPS=5

log_action() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Validate input
if [[ $# -lt 1 ]]; then
  echo "❌ Usage: ./backup.sh <directory_to_backup>"
  exit 1
fi

SOURCE_DIR="$1"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "❌ Error: '$SOURCE_DIR' is not a valid directory."
  log_action "FAILED - '$SOURCE_DIR' does not exist."
  exit 1
fi

# Create backup
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

echo "📦 Creating backup of '$SOURCE_DIR'..."
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

log_action "BACKUP created: $BACKUP_FILE"
echo "✅ Backup saved to '$BACKUP_FILE'"

# Keep only the last 5 backups
echo "🧹 Checking old backups..."
backup_count=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ "$backup_count" -gt "$MAX_BACKUPS" ]]; then
  extras=$((backup_count - MAX_BACKUPS))
  ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -"$extras" | while read -r old_backup; do
    rm -f "$old_backup"
    log_action "DELETED old backup: $old_backup"
    echo "🗑️  Removed old backup: $old_backup"
  done
else
  echo "✅ Backup count ($backup_count) is within the limit ($MAX_BACKUPS)."
fi
