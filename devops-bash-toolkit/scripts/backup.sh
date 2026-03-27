#!/bin/bash

BACKUP_DIR="../backups/"
KEEP_COUNT=5
CURRENT_COUNT=$(ls -1 ../backups | wc -l)


if [[ -d $1 ]]; then
	# Define source directory and backup location
	SOURCE_DIR=$1
	
	# Create timestamp in YYYY-MM-DD_HH-MM-SS format
	TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

	# Create backup filename
	BACKUP_FILE="backup_${TIMESTAMP}.tar.gz"

	# Create backup directory if it doesn't exist
	#mkdir -p "$BACKUP_DIR"
	
	if [[ $CURRENT_COUNT -eq $KEEP_COUNT ]]; then
		# Delete older backups, keeping only the last KEEP_COUNT
		OLDEST_BACKUP=$(ls -t ${BACKUP_DIR}/backup_*.tar.gz 2>/dev/null | tail -n 1)
		ls -t ${BACKUP_DIR}/backup_*.tar.gz 2>/dev/null | tail -n 1 | xargs rm -f
		echo "[$TIMESTAMP] Backup deleted successfully: deleted $OLDEST_BACKUP to accomodate a new backup" >> ../logs/backups.log
	fi

	# Create the backup
	tar -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$SOURCE_DIR" .

	# Check if backup was successful
	if [ $? -eq 0 ]; then
	    echo "[$TIMESTAMP] Backup created successfully: $BACKUP_FILE" >> ../logs/backups.log
	else
	    echo "Error: Backup failed!"
	    exit 1
	fi
else
	echo "Error: The directory doesn't exist"

fi

