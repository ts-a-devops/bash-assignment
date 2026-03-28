#!/bin/bash

#store backup in ../backup
DIR="$1"
BACKUP_DIR="../backup"
mkdir -p "$BACKUP_DIR"

if [[ -z "$1" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

if [[ ! -d "$DIR" ]]; then
    echo "Error: Directory $DIR does not exist."
    exit 1
fi

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

echo "Creating backup of '$DIR' ....."
tar -czf "$BACKUP_FILE" "$DIR"

if [[ $? -eq 0 ]]; then
    echo "Backup created successfully: $BACKUP_FILE"

    (cd "$BACKUP_DIR" && ls -t backup_*.tar.gz | tail -n +6 | xargs -I {} rm -- {} 2>/dev/null || true)
    echo "Old backups deleted, keeping only the 5 most recent ones."
else
    echo "Error creating backup."
    exit 1
fi