#!/bin/bash

backup_folder="backup"
log_folder="logs"
log_file="$log_folder/backup.log"

# create log and backup folder if it does not exist
cd ..
mkdir -p "$log_folder"
mkdir -p "$backup_folder"

echo "=== Backup ===" | tee -a "$log_file"

source_folder=$1

# directory validation and creating a compressed backup
if [[ ! -d "$source_folder"  ]]; then
   echo "This directory does not exist" | tee -a "$log_file"
   exit 1
fi

timestamp=$(date +"%Y%m%d_%H$M%S")
backup_file="$backup_folder/backup_$timestamp.tar.gz"

# create compressed backup
tar -cf "$backup_file" "$source_folder"

echo "Backup file successfully created" | tee -a "$log_file"

# keep only last 5 backups
ls -t $backup_folder/backup*.tar.gz | tail -n +6 | xargs -r rm

echo "Older backup cleaned" | tee -a "$log_file"
