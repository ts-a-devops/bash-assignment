#!/bin/bash

SOURCE_DIR=$1
BACKUP_DIR="../backups"
LOG_FILE="../log/backup.log"

if [[ ! -d "$SOURCE_DIR" ]]; then
	echo "Error: Directory does not exist" | tee -a "$LOG_FILE"

    echo "Usage: $0 <Source directory>" | tee -a "$LOG_FILE"
     exit 1
      fi

 TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
 BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
    
    tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

   echo "Backup created: $BACKUP_FILE" | tee -a "$LOG_FILE"

# Keep only last 5 backups

 ls -t $BACKUP_DIR/backup_*.tar.gz | tail -n +6 | xargs -r rm

   echo "Old backups cleaned up" | tee -a "$LOG_FILE"

