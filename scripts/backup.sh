#!/bin/bash

#Directory for backups and logs
BACKUP_DIR="backups"
LOG_DIR="logs"
LOG_FILE="LOG_DIR/backup.log"

#Create directories if they dont exist
mkdir -p "BACKUP_DIR"
mkdir -p "LOG_DIR"

#Check if directory argument is provided 
if  [[ -z "$1" ]]; then
	echo "Usage: $0 <directory_to_backup>" | tee -a "$LOG_FILE"
	exit 1
fi

SOURCE_DIR="$1"

#Validate that the source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
	echo "Error: Directory '$SOURCE_DIR' does not exist." | tee -a "$LOG_FILE"
	exit 1
fi

#Generate timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

#Create compressed backup
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" . 2>>"$LOG_FILE"

if  [[ $? -eq 0 ]]; then
	echo "Backup successful: $BACKUP_FILE" | tee -a "$LOG_FILE"
else 
	echo "Backup failed for $SOURCE_DIR" | tee -a "$LOG_FILE"
	exit 1
fi

#Keep only the 5 backups
BACKUP_COUNT=$(ls -1 "BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
if [[ "$BACKUP_COUNT" -gt 5 ]]; then
	#Find the oldest backups and delete them
	ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +6  | while read OLD_BACKUP; do
	rm -f "$OLD_BACKUP"
	echo "Deleted old backup: $OLD_BACKUP" | tee -a "$LOG_FILE"
done
fi

