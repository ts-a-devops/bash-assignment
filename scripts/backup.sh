#!/bin/bash

echo "This script backups up the specified directory"

read -p "Enter the directory: " directory

if [ -d $directory ]; then
   tar -czvf backups/backup_"$(date +"%F_%T")".tar.gz "$directory"
   echo "$(date) - SUCCESS: Backup of $directory successful" 2>&1 | tee -a logs/backup.log 
else 
   echo "$(date) - FAILURE: Directory $directory does not exist" 2>&1 | tee -a logs/backup.log
fi

# Check to see if backups are greater than 5
# If yes, list dir, skip first 5 lines and delete the remaining files
num_files=$(ls backups | wc -l)
if [[ $num_files -gt 5 ]]; then
   ls -t backups/* | tail -n +6 | xargs rm -f
   echo "$(date) - SUCCESS: Pruned extra backup(s)" 2>&1 | tee -a logs/backup.log
fi  
