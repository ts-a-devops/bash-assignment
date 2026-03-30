#!/bin/bash
SOURCE_DIR=$1
BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/backup.log"

# Ensure necessary directories exist
mkdir -p "$BACKUP_DIR" logs

# 1. Validate that the directory exists
if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: No directory provided. Usage: $0 <directory>" | tee -a "$LOG_FILE"
    exit 1
elif [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

# 2. Create a compressed backup
# Format: backup_<timestamp>.tar.gz
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR" 2>>"$LOG_FILE"

if [[ $? -eq 0 ]]; then
    echo "Backup successful: $BACKUP_FILE" | tee -a "$LOG_FILE"
else
    echo "Backup failed!" | tee -a "$LOG_FILE"
    exit 1
fi

# 3. Keep only the last 5 backups (Retention Policy)
# ls -t sorts by time (newest first)
# tail -n +6 starts picking files from the 6th one onwards
ls -t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm

echo "Retention check complete. Kept only the 5 most recent backups." >> "$LOG_FILE"
