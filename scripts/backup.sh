#!/bin/bash
#
BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"

set -euo pipefail

DIR=${1:-}
LOG_FILE="logs/backup.log"

if [[ -z "$DIR" || ! -d "$DIR" ]]; then
	    echo "Error: Valid directory required." | tee -a "$LOG_FILE"
	        exit 1
fi

timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$DIR"

echo "Backup created: $backup_file" | tee -a "$LOG_FILE"


 ls -t backups/backup_*.tar.gz | tail -n +6 | while read -r old; do
     rm -f "$old"
         echo "Deleted old backup: $old" | tee -a "$LOG_FILE"
         done
