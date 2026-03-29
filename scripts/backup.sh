#!/bin/bash

# Create backups folder and log file
mkdir -p backups
mkdir -p logs
LogFile="logs/backup.log"

# Accept directory as input
directory=$1

# Validate inputs
if [[ -z "$directory" ]]; then
	    echo "Error: No directory specified." | tee -a "$LogFile"
	        exit 1
fi

if [[ ! -d "$directory" ]]; then
	    echo "Error: Directory '$directory' does not exist." | tee -a "$LogFile"
	        exit 1
fi

# Create timestamped backup

timestamp=$(date +%F_%H-%M-%S)
backup_file="backups/backup_${timestamp}.tar.gz"

tar -czf "$backup_file" "$directory"
echo "Backup created: $backup_file" | tee -a "$LogFile"

# Keep only the last 5 backups (simpler way)

ls -t  $backups/backup_*.tar.gz | tail -n +6 | xargs -r rm -f
if [[ $? -eq 0 ]]; then
	    echo "Old backups deleted, keeping only the latest 5" | tee -a "$LogFile"
fi



