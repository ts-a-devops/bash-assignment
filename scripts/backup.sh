#!/bin/bash

mkdir -p logs backups
LOG_FILE="logs/backup.log"

directory="$1"

if [[ -z "$directory" ]]; then
    echo "Usage: ./scripts/backup.sh <directory>" | tee -a "$LOG_FILE"
    exit 1
fi

if [[ ! -d "$directory" ]]; then
    echo "Error: Directory does not exist" | tee -a "$LOG_FILE"
    exit 1
fi

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_file="backups/backup_$(basename "$directory")_$timestamp.tar.gz"

tar -czf "$backup_file" "$directory"

echo "Backup created: $backup_file" | tee -a "$LOG_FILE"

backups=( $(ls -1t backups/backup_*.tar.gz 2>/dev/null) )

if (( ${#backups[@]} > 5 )); then
    for old_backup in "${backups[@]:5}"; do
        rm -f "$old_backup"
        echo "Deleted old backup: $old_backup" | tee -a "$LOG_FILE"
    done
fi
