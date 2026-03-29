#!/bin/bash

# 1. Setup folders and log file
mkdir -p backups
LOG_FILE="logs/backup_activity.log"
mkdir -p logs

# 2. Get the folder to backup from the user
SOURCE_DIR=$1

# 3. Validation: Did the user provide a folder?
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 [directory_to_backup]"
    exit 1
fi

# 4. Validation: Does that folder actually exist?
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' not found."
    exit 1
fi

# 5. Create the backup file name with a timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backups/backup_$TIMESTAMP.tar.gz"

# 6. Run the backup command
echo "Backing up $SOURCE_DIR..."
if tar -czf "$BACKUP_NAME" "$SOURCE_DIR" 2>> "$LOG_FILE"; then
    echo "[$TIMESTAMP] SUCCESS: Backed up $SOURCE_DIR to $BACKUP_NAME" >> "$LOG_FILE"
    echo "Backup completed successfully."
else
    echo "[$TIMESTAMP] ERROR: Backup failed for $SOURCE_DIR" >> "$LOG_FILE"
    echo "Backup failed. check logs/backup_activity.log"
    exit 1
fi

# 7. Cleanup: Keep only the 5 most recent backups
# 'ls -t' sorts by time (newest first). 'tail -n +6' targets everything after the 5th file.
echo "Cleaning up old backups..."
ls -t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm
echo "Cleanup complete. Only the 5 most recent backups remain."
