#!/bin/bash

LOG_FILE="../logs/backup.log"
BACKUP_DIR="../backups"

mkdir -p $BACKUP_DIR

dir=$1

if [ ! -d "$dir" ]; then
  echo "Directory does not exist!" | tee -a $LOG_FILE
  exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_file=$BACKUP_DIR/backup_$timestamp.tar.gz"

tar -czf $backup_file $dir

echo "Backup created: $backup_file" | tee -a $LOG_FILE

# Keep only last 5 backups
ls -t $BACKUP_DIR | tail -n +6 | xargs -I {} rm -- "$BACKUP_DIR/{}"
