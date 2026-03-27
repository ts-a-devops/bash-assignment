#!/bin/bash


mkdir -p backups logs
LOG_FILE="logs/backup.log"

SOURCE_DIR="$1"
TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")


if [[ -z "$SOURCE_DIR" ]]; then
   echo "Usage: $0 <directory_to_backup>"
   exit 1
fi


if [[ ! -d "$SOURCE_DIR" ]]; then
   message="[$(date +"%Y-%m-%d %H:%M:%S")] Error:Directoy '$SOURCE_DIR' does not exist."
   echo "$message"
   echo "$message" >> "$LOG_FILE"
   exit 1
fi

BASENAME=$(basename "SOURCE_DIR")
BACKUP_FILE="backups/backup_${BASENAME}_$
{TIMESTAMP}.tar.gz"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [[ $? -eq 0 ]]; then
   message="[$(date +"%Y-%m-%d %H:%M:%S")] Backup created successfully: $BACKUP_FILE"
   echo "$message"
   echo "$message" >> "LOG_FILE"
   exit 1
fi

else
  message="[$(date +"%Y-%m-%d %H:%M:%S")] Error:Backup failed for '$SOURCE_DIR'."
  echo "$message"
  echo "$message" >> "LOG_FILE"
  exit 1
fi


# Keep only the latest 5 backups
ls -1t backups/*.tar.gz 2>/dev/null | tail -n +6 | while read -r old_backup; do
        rm -f "$old_backup"
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] Deleted old backup: $old_backup" >> "$LOG_FILE"
done


