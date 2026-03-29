#!/bin/bash


mkdir -p backups logs

LOG_FILE="logs/backup.log"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

log_action() {

	 echo "[$TIMESTAMP] $1" >> "$LOG_FILE"
}

if [ -z "$1" ]; then
	 echo "Error: Please provide a directory to back up"
	 exit 1
fi

SOURCE_DIR="$1"

if [ ! -d "$SOURCE_DIR" ]; then
	 echo "Error: Directory does not exist"
	 log_action "BACKUP FAILED - $SOURCE_DIR not found"
	 exit 1
fi
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
	echo "Backup created: $BACKUP_FILE"
	log_action "BACKUP SUCCESS - $SOURCE_DIR -> $BACKUP_FILE"
else
	echo "Backup failed"
	log_action "BACKUP FAILED - error creating archive"
	exit 1
fi

ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | while read file; do
    rm -f "$file"
    log_action "DELETED OLD BACKUP - $file"
done

