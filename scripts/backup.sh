#!/bin/bash

BACKUP_DIR="./backups"
BACKUP_LOG="logs/backup.log"

# Create Backup folder and backup log if it doesn't exist
if [[ ! -d "$BACKUP_DIR" ]]; then
    mkdir "$BACKUP_DIR"
fi

if [[ ! -f "$BACKUP_LOG" ]]; then
    touch "$BACKUP_LOG"
fi

# Receive dir input and validates
dir_input=$1
if [[ -z "$dir_input" ]]; then
    echo "Please input a directory to backup. Format: $0 <dir_name>"
    exit 1
elif [[ ! -d "$dir_input" ]]; then
    echo "Error: Directory does not exist! Ensure input directory exists"
    exit 1
fi

# Create compressed backup
timestamp=$(date +%Y_%m_%d_%H_%M_%S)
backup_name="${dir_input}_backup_${timestamp}.tar.gz"
tar -czf "$BACKUP_DIR/$backup_name" "$dir_input"

# Log backup activity
LOG_TIMESTAMP=$(date +'%F %T')
echo "[$LOG_TIMESTAMP] Backup of $dir_input has been successfully created" >> "$BACKUP_LOG" 
echo "Directory $dir_input has been backed up and logged successfully"


# Delete old backups, keep the 5 newest ones
files=($(ls -t "$BACKUP_DIR"/*.tar.gz))
if [[ ${#files[@]} -gt 5 ]]; then
    filesToDelete="${files[@]:5}"
    rm $filesToDelete
    echo "[$LOG_TIMESTAMP] Deleted old backups successfully: $filesToDelete" >> "$BACKUP_LOG"
    echo "old backups have been deleted. Check log file for more details on deleted file(s)"
fi
