#!/bin/bash

# 1. Variables
SOURCE_DIR=$1
BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="logs/backup.log"

# 2. Check if user provided a directory
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: ./backup.sh <directory_to_backup>"
    exit 1
fi

# 3. Check if the directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# 4. Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 5. Create the compressed backup (tar.gz)
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"

# 6. Log the activity
if [ $? -eq 0 ]; then
    echo "Successfully created backup: $BACKUP_DIR/$BACKUP_NAME"
    echo "$(date): Backed up $SOURCE_DIR to $BACKUP_NAME" >> $LOG_FILE
else
    echo "Backup failed!"
    exit 1
fi

# 7. Bonus: Keep only the last 5 backups (Delete older ones)
ls -t $BACKUP_DIR/backup_*.tar.gz | tail -n +6 | xargs -r rm
