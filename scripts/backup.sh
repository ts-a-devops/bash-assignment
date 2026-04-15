#!/bin/bash
set -euo pipefail

# Create necessary directories
mkdir -p backups logs

logfile="logs/backup.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$logfile"
}

# Function to display usage
usage() {
    echo "Usage: $0 <directory>"
    echo "Example: $0 /home/user/documents"
    exit 1
}

# Check if directory argument is provided
if [[ $# -ne 1 ]]; then
    echo "Error: Please provide exactly one directory path" >&2
    usage
fi

source_dir="$1"

# Validate that directory exists
if [[ ! -d "$source_dir" ]]; then
    echo "Error: Directory '$source_dir' does not exist" >&2
    log_action "FAILED: Backup - Directory '$source_dir' not found"
    exit 1
fi

# Create timestamp and backup filename
timestamp=$(date '+%Y%m%d_%H%M%S')
backup_name="backup_${timestamp}.tar.gz"
backup_path="backups/${backup_name}"

# Create compressed backup
echo "Creating backup of: $source_dir"
log_action "Starting backup of '$source_dir'"

if tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")" 2>/dev/null; then
    backup_size=$(du -h "$backup_path" | cut -f1)
    echo "✓ Backup created: $backup_path ($backup_size)"
    log_action "SUCCESS: Created $backup_name (Size: $backup_size) from '$source_dir'"
else
    echo "Error: Failed to create backup" >&2
    log_action "FAILED: Could not create backup of '$source_dir'"
    exit 1
fi

# Keep only the last 5 backups (delete older ones)
echo "Checking for old backups to remove..."
log_action "Checking backups in 'backups/' directory"

# List backups sorted by name (timestamp descending), skip first 5, delete rest
old_backups=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | sort -r | tail -n +6)

if [[ -n "$old_backups" ]]; then
    while IFS= read -r old_backup; do
        rm "$old_backup"
        echo "  Removed old backup: $(basename "$old_backup")"
        log_action "REMOVED: $(basename "$old_backup") - Keeping only last 5 backups"
    done <<< "$old_backups"
else
    echo "  No old backups to remove (less than 5 total)"
fi

# Show current backups count
backup_count=$(ls -1 backups/backup_*.tar.gz 2>/dev/null | wc -l)
echo "✓ Current backups in 'backups/': $backup_count (max: 5)"
log_action "Backup cleanup complete. Total backups kept: $backup_count"

echo "Backup process finished successfully!"
