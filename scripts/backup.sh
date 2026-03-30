#!/bin/bash

# Configuration
SOURCE_DIR=$1
BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/backup.log"

# 1. Validate: Does the user provide a directory?
if [ -z "$SOURCE_DIR" ]; then
    echo "Error: No directory provided. Usage: $0 [directory]" | tee -a "$LOG_FILE"
    exit 1
fi

# 2. Validate: Does that directory actually exist?
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

# Ensure folders exist
mkdir -p "$BACKUP_DIR"
mkdir -p logs

# 3. Create the compressed backup (tar.gz)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
echo "Starting backup of $SOURCE_DIR..." | tee -a "$LOG_FILE"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"

# Check if tar succeeded ($? is the exit code of the last command)
if [ $? -eq 0 ]; then
    echo "SUCCESS: Saved to $BACKUP_DIR/$BACKUP_NAME" | tee -a "$LOG_FILE"
else
    echo "FAILED: Backup encountered an error." | tee -a "$LOG_FILE"
    exit 1
fi

# 4. Retention Logic: Keep only the newest 5 backups
echo "Cleaning up... (Keeping 5 most recent)" | tee -a "$LOG_FILE"
ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "Backup process finished at $(date)" | tee -a "$LOG_FILE"
