#!/usr/bin/env bash

mkdir -p logs backups
LOG_FILE="logs/backup.log"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

source_dir="$1"
timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"

if [[ ! -d "$source_dir" ]]; then
  message="[$(date '+%Y-%m-%d %H:%M:%S')] Error: Directory '$source_dir' does not exist."
  echo "$message"
  echo "$message" >> "$LOG_FILE"
  exit 1
fi

base_name="$(basename "$source_dir")"
backup_file="backups/backup_${base_name}_${timestamp}.tar.gz"

if tar -czf "$backup_file" "$source_dir"; then
  message="[$(date '+%Y-%m-%d %H:%M:%S')] Backup created: $backup_file"
  echo "$message"
  echo "$message" >> "$LOG_FILE"
else
  message="[$(date '+%Y-%m-%d %H:%M:%S')] Backup failed for: $source_dir"
  echo "$message"
  echo "$message" >> "$LOG_FILE"
  exit 1
fi

ls -1t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read -r old_backup; do
  rm -f "$old_backup"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deleted old backup: $old_backup" >> "$LOG_FILE"
done
