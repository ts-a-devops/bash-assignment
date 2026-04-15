#!/bin/bash

# nfiguration
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"
SOURCE_DIR=$1

# 1. Validation: Check if a directory was provided and if it exists
if [ -z "$SOURCE_DIR" ]; then
	echo "Usage: $0 <directory_to_backup>"
	exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Directory '$SOURCE_DIR' does not exist." | tee -a "$LOG_FILE"
	exit 1
fi
# Create backup directory if it's missing 
mkdir -p "$BACKUP_DIR"

# 2. Create the compressed backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"

echo "Creating backup of $SOURCE_DIR..."
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
	echo "$(date): Success - Backed up $SOURCE_DIR to $BACKUP_NAME" >> "$LOG_FILE"
	echo "Backup saved: ${BACKUP_DIR}/${BACKUP_NAME}"
else
	echo "$(date): Failure - Backup of $SOURCE_DIR failed" >> "$LOG_FILE"
	exit 1
fi

# 3. Retention: Keep only the last 5 backups
# ls -t sorts by time (newest first): tail -n +6 selects everything after the 5th file
ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs -r rm

echo "Cleanup complete. Keeping only the 5 most recent backups."


