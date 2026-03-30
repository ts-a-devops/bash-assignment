#!/bin/bash

# Backup Script

# Backup directory
backup_dir="../backups"
log_file="../logs/backup.log"

# Create directories if they don't exist
mkdir -p "$backup_dir"
mkdir -p ../logs

# Function to log actions
log_action() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" >> "$log_file"
}

# Check if directory is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a directory to backup"
    echo "Usage: ./backup.sh <directory>"
    exit 1
fi

# Get the directory to backup
dir_to_backup=$1

# Check if directory exists
if [ ! -d "$dir_to_backup" ]; then
    echo "Error: Directory '$dir_to_backup' does not exist"
    log_action "FAILED: Directory '$dir_to_backup' does not exist"
    exit 1
fi

# Get timestamp
timestamp=$(date +%Y%m%d_%H%M%S)

# Create backup filename
backup_filename="backup_${timestamp}.tar.gz"
backup_path="$backup_dir/$backup_filename"

# Create the backup
echo "Creating backup of '$dir_to_backup'..."
tar -czf "$backup_path" "$dir_to_backup"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully: $backup_filename"
    log_action "SUCCESS: Created backup $backup_filename of $dir_to_backup"
else
    echo "Error: Failed to create backup"
    log_action "FAILED: Failed to create backup of $dir_to_backup"
    exit 1
fi

# Count current backups
backup_count=$(ls -1 "$backup_dir"/backup_*.tar.gz 2>/dev/null | wc -l)

# Keep only the last 5 backups
if [ "$backup_count" -gt 5 ]; then
    echo "Cleaning up old backups..."
    # List old backups and remove oldest ones
    ls -1t "$backup_dir"/backup_*.tar.gz | tail -n +6 | while read old_backup; do
        rm "$old_backup"
        echo "Removed old backup: $(basename $old_backup)"
        log_action "Removed old backup: $(basename $old_backup)"
    done
fi

# Display backup info
echo ""
echo "Backup Summary:"
echo "  Location: $backup_path"
echo "  Size: $(du -h $backup_path | cut -f1)"
echo "  Total backups: $(ls -1 $backup_dir/backup_*.tar.gz 2>/dev/null | wc -l)"
