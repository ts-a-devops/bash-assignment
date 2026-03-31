#!/bin/bash
dir=$1
#Check if the directory exist
if [[ ! -d "$dir" ]]; then
    echo " $dir" is not a directory"" 
exit 1
fi
timestamp=$(date +%F)
backup="../logs/backups-"$timestamp".tar.gz"
backups="../logs/backup.log"

tar -czf "$backup" "$dir"
echo "Backup created: $backup" > $backups

ls -t ../backups | tail -n +6 | xargs rm -f 


