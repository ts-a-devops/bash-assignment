#!/bin/bash

DIR=$1
LOG="logs/backup.log"

if [ ! -d "$DIR" ]; then
  echo "Directory does not exist!" | tee -a $LOG
  exit 1
fi

TIMESTAMP=$(date +%s)
BACKUP="backups/backup_$TIMESTAMP.tar.gz"

tar -czf $BACKUP $DIR

echo "Backup created: $BACKUP" | tee -a $LOG

# Keep only last 5 backups
ls -t backups/ | tail -n +6 | xargs -I {} rm backups/{}
