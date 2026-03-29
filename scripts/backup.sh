#!/bin/bash

# Create necessary directories
mkdir -p backups
mkdir -p logs

log_file="logs/backup.log"

# Function to log messages
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Check if directory argument is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <directory_to_backup>"
    exit 1
fi

source_dir="$1"

# Validate directory exists
if [[ ! -d "$source_dir" ]]; then
    echo "Error: Directory does not exist."
    log_action "BACKUP FAILED - $source_dir not found"
    exit 1
fi

# Generate timestamp and backup filename
timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="backups/backup_${timestamp}.tar.gz"

# Create compressed backup
tar -czf "$backup_file" "$source_dir"

if [[ $? -eq 0 ]]; then
    echo "Backup created: $backup_file"
    log_action "BACKUP SUCCESS - $backup_file"
else
    echo "Error: Backup failed."
    log_action "BACKUP FAILED - error creating archive"
    exit 1
fi

# Keep only the last 5 backups
backup_count=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)


if (( backup_count > 5 )); then
    ls -1t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm
    log_action "DELETED ALL BACKUP EXCEPT THE LAST FIVE "
fi

# if (( backup_count > 5 )); then
#     ls -1t backups/backup_*.tar.gz | tail -n +6 | while read old_backup; do
#         rm -f "$old_backup"
#         log_action "DELETED OLD BACKUP - $old_backup"
#     done
# fi

echo "Backup process completed."