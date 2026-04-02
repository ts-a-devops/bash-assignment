#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs backups
LOG_FILE="logs/backup.log"

target_dir="${1:-}"

# Validate input
if [[ -z "$target_dir" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

if [[ ! -d "$target_dir" ]]; then
  echo "Error: Directory does not exist." | tee -a "$LOG_FILE"
  exit 1
fi

# Create backup
timestamp=$(date '+%F_%H-%M-%S')
backup_file="backups/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" "$target_dir"

echo "Backup created: $backup_file" | tee -a "$LOG_FILE"

# Keep only last 5 backups
ls -1t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read -r old; do
  rm -f "$old"
  echo "Deleted old backup: $old" >> "$LOG_FILE"
done
