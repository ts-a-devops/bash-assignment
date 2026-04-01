#!/bin/bash
# Create folders
mkdir -p backups logs

LOG_FILE="logs/backup.log"

#directory input 
dir=$1

# validate directory input 

 if  [[ -z $dir ]]; then
    echo "Usage: ./backup.sh <directory>" | tee -a "LOG_FILE"
        exit 1
 fi
# validate directory exist

if [[ ! -d "$dir" ]]; then
   echo "Error: Directory does not exist" | tee -a "LOG_FILE"
     echo "$(date): Failed backup (directory not found: $dir)" >> $LOG_FILE | tee -a "LOG_FILE"
   exit 1
fi

# Timestamp
timestamp=$(date +%Y%m%d_%H%M%S)

# Backup filename
backup_file="backups/backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_file" "$dir"

if [[ $? -eq 0 ]]; then
	    echo "Backup successful: $backup_file" | tee -a "LOG_FILE"
	        echo "$(date): Backup created for $dir" >> $LOG_FILE | tee -a "LOG_FILE"
	else
		    echo "Backup failed" | tee -a "LOG_FILE"
		        echo "$(date): Backup failed for $dir" >> $LOG_FILE | tee -a "LOG_FILE"
			    exit 1
fi

# Keep only last 5 backups
cd backups || exit

ls -t backup_*.tar.gz | tail -n +6 | while read file
do
	    rm -f "$file"
	        echo "$(date): Deleted old backup $file" >> "../$LOG_FILE" | tee -a "LOG_FILE"
	done

	

