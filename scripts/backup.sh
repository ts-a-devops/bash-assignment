#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="logs"
BACKUP_DIR="backups"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$LOG_DIR" "$BACKUP_DIR"

if (( $# != 1 )); then
  echo "Usage: ./scripts/backup.sh <directory>"
  exit 1
fi

source_dir="$1"

if [[ ! -d "$source_dir" ]]; then
  echo "Error: '$source_dir' is not a valid directory."
  printf "%s | ERROR | invalid_source:%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$source_dir" >> "$LOG_FILE"
  exit 1
fi

timestamp="$(date '+%Y%m%d_%H%M%S')"
archive_path="$BACKUP_DIR/backup_${timestamp}.tar.gz"

source_parent="$(dirname "$source_dir")"
source_base="$(basename "$source_dir")"

tar_excludes=()
if [[ -d "$source_dir/$BACKUP_DIR" ]]; then
  tar_excludes+=("--exclude=$source_base/$BACKUP_DIR")
fi
if [[ -d "$source_dir/$LOG_DIR" ]]; then
  tar_excludes+=("--exclude=$source_base/$LOG_DIR")
fi

if tar -czf "$archive_path" "${tar_excludes[@]}" -C "$source_parent" "$source_base"; then
  echo "Backup created: $archive_path"
  printf "%s | OK | created:%s | source:%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$archive_path" "$source_dir" >> "$LOG_FILE"
else
  echo "Error: backup creation failed."
  printf "%s | ERROR | failed_source:%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$source_dir" >> "$LOG_FILE"
  exit 1
fi

# Keep only the latest 5 backups. This avoids bash 4-only features (mapfile) for macOS compatibility.
ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | tail -n +6 | while IFS= read -r old_file; do
  rm -f -- "$old_file"
  printf "%s | OK | removed_old_backup:%s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$old_file" >> "$LOG_FILE"
done
