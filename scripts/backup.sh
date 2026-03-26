#!/bin/bash

# Create backups folder
mkdir -p backups
LOG_FILE="backups/backup.log"

# Directory to back up
DIR=$1

# Validate input
if [ -z "$DIR" ]; then
  echo "Usage: ./backup.sh /path/to/directory"
  exit 1
fi

if [ ! -d "$DIR" ]; then
  echo "Error: Directory '$DIR' does not exist."
  exit 1
fi

# Create timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" "$DIR"

# Log backup
echo "$(date): Backed up $DIR to $BACKUP_FILE" >> "$LOG_FILE"
echo "Backup created: $BACKUP_FILE"

# Keep only last 5 backups
cd backups
BACKUPS=($(ls -1tr backup_*.tar.gz 2>/dev/null))
NUM=${#BACKUPS[@]}

if [ "$NUM" -gt 5 ]; then
  NUM_TO_DELETE=$((NUM - 5))
  for ((i=0; i<NUM_TO_DELETE; i++)); do
    rm -f "${BACKUPS[i]}"
    echo "$(date): Deleted old backup ${BACKUPS[i]}" >> "$LOG_FILE"
  done
fi
