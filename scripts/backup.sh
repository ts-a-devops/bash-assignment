#!/usr/bin/env bash

mkdir -p backups logs
LOG_FILE="logs/backup.log"

source_dir="$1"

if [[ -z "$source_dir" ]]; then
  echo "Error: directory path required."
  exit 1
fi

if [[ ! -d "$source_dir" ]]; then
  message="Error: directory '$source_dir' does not exist."
  echo "$message"
  echo "$(date '+%F %T') - $message" >> "$LOG_FILE"
  exit 1
fi

timestamp="$(date '+%F_%H-%M-%S')"
backup_file="backups/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" "$source_dir"

message="Backup created: $backup_file"
echo "$message"
echo "$(date '+%F %T') - $message" >> "$LOG_FILE"

ls -1t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f

echo "$(date '+%F %T') - Cleanup completed, kept latest 5 backups." >> "$LOG_FILE"
