#!/bin/bash
# backup.sh - Creates compressed backups of a directory

LOG_DIR="$(dirname "$0")/../logs"
BACKUP_DIR="$(dirname "$0")/../backups"
mkdir -p "$LOG_DIR" "$BACKUP_DIR"
LOG_FILE="$LOG_DIR/backup.log"

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Validate input
SOURCE_DIR=$1

if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: Please provide a directory to back up."
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    log_action "FAILED — Directory '$SOURCE_DIR' not found."
    exit 1
fi

# Create backup filename
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

echo "==============================="
echo "         BACKUP UTILITY        "
echo "==============================="
echo "Source:  $SOURCE_DIR"
echo "Backup:  $BACKUP_PATH"
echo ""

# Create compressed backup
tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null

if [[ $? -eq 0 ]]; then
    echo "✅ Backup created successfully: $BACKUP_NAME"
    log_action "SUCCESS — Backed up '$SOURCE_DIR' to '$BACKUP_PATH'"
else
    echo "❌ Backup failed!"
    log_action "FAILED — Could not compress '$SOURCE_DIR'"
    exit 1
fi

# Keep only the last 5 backups
echo ""
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)

if (( BACKUP_COUNT > 5 )); then
    echo "🗑️  Cleaning old backups (keeping last 5)..."
    EXTRAS=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6)
    while IFS= read -r OLD_BACKUP; do
        rm "$OLD_BACKUP"
        echo "   Deleted: $(basename "$OLD_BACKUP")"
        log_action "DELETED old backup: $OLD_BACKUP"
    done <<< "$EXTRAS"
fi

echo ""
echo "📦 Total backups stored: $(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)"
echo "Backup log saved to: $LOG_FILE"
