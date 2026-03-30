#!/bin/bash
mkdir -p backups logs

LOG_FILE="logs/backup.log"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")


SOURCE_DIR=$1


if [[ -z "$SOURCE_DIR" ]]; then
    echo " Please provide a directory to back up"
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi


if [[ ! -d "$SOURCE_DIR" ]]; then
    echo " Directory does not exist"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - BACKUP FAILED: $SOURCE_DIR not found" | tee -a "$LOG_FILE"
    exit 1
fi

BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"


echo " Cleaning old backups..."


OLD_BACKUPS=$(ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6)

for file in $OLD_BACKUPS; do
    rm -f "$file"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - DELETED OLD BACKUP: $file" | tee -a "$LOG_FILE"
done