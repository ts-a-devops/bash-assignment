#!/bin/bash

backupdir=~/bash-assignment/backups
logfile=~/bash-assignment/logs/backup.log
source_dir=$1

# Validate input
if [ -z "$source_dir" ]; then
    echo "Error: Please provide a directory to backup."
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

# Validate directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Directory '$source_dir' does not exist."
    exit 1
fi

# Create backup with timestamp
timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="$backupdir/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$source_dir"
echo "Backup created: $backup_file"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup created: $backup_file" >> "$logfile"

# Keep only last 5 backups
backup_count=$(ls $backupdir/backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$backup_count" -gt 5 ]; then
    ls -t $backupdir/backup_*.tar.gz | tail -n +6 | xargs rm -f
    echo "Old backups cleaned up."
fi
