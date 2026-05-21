#!/bin/bash

mkdir -p backups logs

if [ -z "$1" ]
then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

DIR=$1

if [ ! -d "$DIR" ]
then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/backup_${TIMESTAMP}.tar.gz"

tar -czf "$BACKUP_FILE" "$DIR" && echo "Backup created: $BACKUP_FILE"

# Keep only last 5 backups
cd backups || exit
ls -t *.tar.gz 2>/dev/null | tail -n +6 | xargs -I {} rm -- {} 2>/dev/null || true

echo "$(date) - Backup created for $DIR" >> ../logs/backup.log
echo "Backup completed and old backups cleaned."