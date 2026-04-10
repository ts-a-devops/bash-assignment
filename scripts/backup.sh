#!/usr/bin/env bash

LOG_DIR="logs"
BACKUP_DIR="backups"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log_action() {
  echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

source_dir="$1"

if [[ -z "$source_dir" ]]; then
  log_action "Backup failed: No directory provided. Usage: $0 <directory>"
  exit 1
fi

if [[ ! -d "$source_dir" ]]; then
  log_action "Backup failed: '$source_dir' is not a valid directory."
  exit 1
fi

source_base="$(basename "$source_dir")"
archive_name="backup_${source_base}_$(date +%Y%m%d_%H%M%S).tar.gz"
archive_path="$BACKUP_DIR/$archive_name"

if tar -czf "$archive_path" -C "$(dirname "$source_dir")" "$source_base"; then
  log_action "Backup successful: '$source_dir' -> '$archive_path'"
else
  log_action "Backup failed while creating archive for '$source_dir'"
  exit 1
fi

# Keep only the 5 most recent backups.
ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | awk 'NR>5' | while IFS= read -r old_backup; do
  rm -f "$old_backup"
  log_action "Removed old backup: '$old_backup'"
done
