#!/bin/bash


SOURCE_DIR=$1
BACKUP_DIR="backups"
LOG_FILE="logs/backup.log"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"


# Check if the user provided an input
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi  

mkdir -p "$BACKUP_DIR"
mkdir -p "logs"

# Check if the directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo " Directory '$SOURCE_DIR' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

# Create the Backup
{
    echo "--- Backup Started: $(date) ---"
    
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE_DIR"
    
    if [ $? -eq 0 ]; then
        echo "SUCCESS: Created $BACKUP_NAME"
    else
        echo "FAIL: Backup failed for $SOURCE_DIR"
    fi

    echo "Cleaning up old backups..."
    

    ls -t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6 | xargs -d '\n' rm -f -- 2>/dev/null
    
    echo "Current backups kept:"
    ls "$BACKUP_DIR"
    
} | tee -a "$LOG_FILE"
