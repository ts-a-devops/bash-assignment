#!/bin/bash

# =========================================================
# BACKUP SCRIPT
# - Accepts a directory
# - Creates compressed backup
# - Keeps only last 5 backups
# - Logs all activity
# =========================================================


# ---------------- SETUP DIRECTORIES ----------------

backup_dir="backups"
log_dir="logs"
log_file="${log_dir}/backup.log"


if [[ ! -d "$log_dir" ]]; then
  mkdir -p "$log_dir"
fi

if [[ ! -d "$backup_dir" ]]; then
  mkdir -p "$backup_dir"
fi


# ---------------- VALIDATION ----------------

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <directory-to-backup>"
  exit 1
fi

source_dir=$1

# Check if directory exists
if [[ ! -d "$source_dir" ]]; then
  echo "Error: Directory does not exist."
  echo "$(date): BACKUP FAILED - $source_dir not found" >> "$log_file"
  exit 1
fi


# ---------------- CREATE BACKUP ----------------

timestamp=$(date +%F_%H-%M-%S)

backup_file="${backup_dir}/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" "$source_dir"

echo "Backup created: $backup_file"
echo "$(date): BACKUP CREATED - $backup_file from $source_dir" >> "$log_file"


# ---------------- KEEP ONLY LAST 5 BACKUPS ----------------

backup_count=$(ls -1t "$backup_dir"/backup_*.tar.gz 2>/dev/null | wc -l)

if [[ "$backup_count" -gt 5 ]]; then

  # delete older backups (beyond latest 5)
  ls -1t "$backup_dir"/backup_*.tar.gz | tail -n +6 | while read old_backup; do
    rm -f "$old_backup"
    echo "$(date): DELETED OLD BACKUP - $old_backup" >> "$log_file"
  done

fi


# ---------------- COMPLETION MESSAGE ----------------

echo "Backup process completed successfully."
