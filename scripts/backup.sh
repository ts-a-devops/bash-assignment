#!/bin/bash

mkdir -p logs backups

SOURCE=$1

if [ -z "$SOURCE" ]; then
  echo "Error: Please provide a directory to backup"
  echo "Usage: ./backup.sh <directory>"
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Error: Directory '$SOURCE' does not exist!"
  exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="backups/backup_$TIMESTAMP.tar.gz"

tar -czf $BACKUP_NAME $SOURCE
echo "Backup created: $BACKUP_NAME"

echo "$(date): Backed up '$SOURCE' to '$BACKUP_NAME'" >> logs/backup.log

cd backups
ls -t | tail -n +6 | xargs -r rm
cd ..
echo "Old backups cleaned. Keeping last 5 only."
