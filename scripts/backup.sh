#!/bin/bash
# backup.sh - backup directory with rotation and logging

LOGFILE="logs/backup.log"
BACKUP_DIR="backups"
mkdir -p logs
mkdir -p $BACKUP_DIR

# Check input
if [ $# -lt 1 ]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

SOURCE_DIR=$1

# Validate directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory $SOURCE_DIR does not exist"
    echo "$(date '+%F %T') - BACKUP FAILED - $SOURCE_DIR missing" >> $LOGFILE
    exit 1
fi

# Create backup
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf $BACKUP_FILE $SOURCE_DIR
if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_FILE"
    echo "$(date '+%F %T') - BACKUP CREATED - $BACKUP_FILE" >> $LOGFILE
else
    echo "Backup failed"
    echo "$(date '+%F %T') - BACKUP FAILED - $SOURCE_DIR" >> $LOGFILE
    exit 1
fi

# Keep only last 5 backups
BACKUPS_COUNT=$(ls -1 $BACKUP_DIR | wc -l)
if [ $BACKUPS_COUNT -gt 5 ]; then
    TO_DELETE=$(ls -1t $BACKUP_DIR | tail -n +6)
    for f in $TO_DELETE; do
        rm "$BACKUP_DIR/$f"
        echo "$(date '+%F %T') - OLD BACKUP REMOVED - $f" >> $LOGFILE
    done
fi
