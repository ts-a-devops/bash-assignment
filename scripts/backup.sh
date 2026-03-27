#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
BACKUP_DIR="$PROJECT_ROOT/backups"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log_message() {
  printf '[%s] %s\n' "$(timestamp)" "$1" >> "$LOG_FILE"
}

input_dir="${1:-}"

if [[ -z "$input_dir" ]]; then
  printf 'Usage: %s <directory>\n' "$(basename "$0")"
  exit 1
fi

if [[ ! -d "$input_dir" ]]; then
  message="Error: directory does not exist: $input_dir"
  printf '%s\n' "$message"
  log_message "$message"
  exit 1
fi

resolved_dir="$(cd "$input_dir" && pwd)"
dir_name="$(basename "$resolved_dir")"
archive_name="backup_$(date '+%Y%m%d_%H%M%S').tar.gz"
archive_path="$BACKUP_DIR/$archive_name"

tar -czf "$archive_path" -C "$(dirname "$resolved_dir")" "$dir_name"

message="Backup created: $archive_path"
printf '%s\n' "$message"
log_message "$message from $resolved_dir"

mapfile -t backup_files < <(find "$BACKUP_DIR" -maxdepth 1 -type f -name 'backup_*.tar.gz' -printf '%T@ %p\n' | sort -n | awk '{print $2}')

if (( ${#backup_files[@]} > 5 )); then
  remove_count=$((${#backup_files[@]} - 5))
  for ((i = 0; i < remove_count; i++)); do
    old_backup="${backup_files[$i]}"
    rm -f -- "$old_backup"
    log_message "Old backup removed: $old_backup"
  done
fi
