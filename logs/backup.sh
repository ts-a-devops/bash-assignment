#!/bin/bash

# Exit immediately if a command fails
set -euo pipefail

# Function: show usage
usage() {
    echo "Usage: $0 /path/to/directory"
    exit 1
#!/bin/bash

# Exit on error
set -e

# === 1. Validate input ===
SOURCE_DIR="$1"

if [[ -z "$SOURCE_DIR" ]]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# === 2. Setup directories ===
BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# === 3. Create backup ===
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

echo "✔ Backup created: $BACKUP_FILE"

# === 4. Log activity ===
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created: $BACKUP_FILE" >> "$LOG_FILE"

# === 5. Keep only last 5 backups ===
backups=$(ls -1t $BACKUP_DIR/backup_*.tar.gz 2>/dev/null)
count=$(echo "$backups" | wc -l)

if (( count > 5 )); then
    echo "$backups" | tail -n +6 | while read file; do
        rm -f "$file"
        echo "🗑 Deleted old backup: $file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deleted: $file" >> "$LOG_FILE"
    done
fi}

# Ensure a directory argument is provided
[[ $# -ne 1 ]] && usage

SOURCE_DIR="$1"

# Validate the directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Setup backup and log directories
BACKUP_DIR="backups"
LOG_DIR="logs"
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# Create timestamp for backup filename
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz"

# Perform the backup
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Log backup creation
echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup created: $BACKUP_FILE" >> "${LOG_DIR}/backup.log"
echo "✔ Backup completed: $BACKUP_FILE"

# Cleanup old backups (keep last 5 only)
BACKUP_COUNT=$(ls -1 ${BACKUP_DIR}/backup_*.tar.gz 2>/dev/null | wc -l)
if [[ $BACKUP_COUNT -gt 5 ]]; then
    OLDEST_BACKUPS=$(ls -1t ${BACKUP_DIR}/backup_*.tar.gz | tail -n +6)
    for f in $OLDEST_BACKUPS; do
        rm -f "$f"
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] Deleted old backup: $f" >> "${LOG_DIR}/backup.log"
        echo "🗑 Deleted old backup: $f"
    done
fi
