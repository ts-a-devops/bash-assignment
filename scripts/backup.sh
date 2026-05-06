#!/bin/bash

mkdir -p backups
mkdir -p logs

LOG_FILE="logs/backup.log"

SOURCE=$1
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

echo "===== BACKUP STARTED =====" | tee -a "$LOG_FILE"

# -------------------------
# Validate input
# -------------------------
if [ -z "$SOURCE" ]; then
  echo "Error: No directory provided." | tee -a "$LOG_FILE"
  echo "Usage: $0 <directory>" | tee -a "$LOG_FILE"
  exit 1
fi

# -------------------------
# Check directory exists
# -------------------------
if [ ! -d "$SOURCE" ]; then
  echo "Error: Directory '$SOURCE' does not exist." | tee -a "$LOG_FILE"
  exit 1
fi

# -------------------------
# Create backup
# -------------------------
BACKUP_NAME="backups/backup_$(basename "$SOURCE")_$DATE.tar.gz"

tar -czf "$BACKUP_NAME" "$SOURCE"

echo "Backup created: $BACKUP_NAME" | tee -a "$LOG_FILE"

# -------------------------
# Keep only last 5 backups
# -------------------------
echo "Cleaning old backups (keeping last 5)..." | tee -a "$LOG_FILE"

ls -t backups/*.tar.gz 2>/dev/null | tail -n +6 | while read OLD; do
  rm -f "$OLD"
  echo "Deleted old backup: $OLD" | tee -a "$LOG_FILE"
done

echo "===== BACKUP COMPLETED =====" | tee -a "$LOG_FILE"
