#!/bin/bash

LOG_DIR="logs"
BACKUP_DIR="backups"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

log_action() {
    echo "[$(date +%Y-%m-%d
%H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <directory_to_backup>"
    log_action "FAILED: No directory specified"
    exit 1
fi

source_dir=$1

if [[ ! -d "$source_dir" ]]; then
    echo "Error: Directory '$source_dir' does not exist"
    log_action "FAILED: Directory not found - $source_dir"
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_name="backup_${timestamp}.tar.gz"
backup_path="$BACKUP_DIR/$backup_name"

echo "Creating backup of '$source_dir'..."
tar -czf "$backup_path" "$source_dir"

if [[ $? -eq 0 ]]; then
    echo "Backup created: $backup_path"
    log_action "SUCCESS: Created backup $backup_name from $source_dir"
else
    echo "Error: Backup failed"
    log_action "FAILED: Backup creation failed for $source_dir"
    exit 1
fi

cd "$BACKUP_DIR" || exit
backup_count=$(ls -1 backup_*.tar.gz 2>/dev/null | wc -l)

if [[ $backup_count -gt 5 ]]; then
    ls -1t backup_*.tar.gz | tail -n +6 | xargs rm -f
    log_action "CLEANUP: Removed old backups, kept 5 most recent"
fi

echo "Backup process completed. Total backups: $(ls -1 backup_*.tar.gz 2>/dev/null | wc -l)"
