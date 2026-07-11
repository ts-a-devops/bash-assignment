#!/bin/bash

mkdir -p backups

exec > >(tee -a "logs/backup.log") 2>&1

dir=$1

if [[ -z "$dir" ]]; then  
     echo "Error: please provide a directory"
     exit 1
fi

if [[ ! -d "$dir" ]]; then
      echo "Error: '$dir' does not exist or is not a directory"
      exit 1
else
	echo "'$dir' exists"
fi

#create the backup
timestamp=$(date +%Y%m%d_%H%M%S)
backup_name="backup_$timestamp.tar.gz"

echo "Backing up '$dir' to backups/$backup_name ..."
 tar -czf "backups/$backup_name" "$dir"

if [[ $? -eq 0 ]]; then
	echo "Backup created: backups/$backup_name"
else
	echo "Error: backup failed"
exit 1
fi

# keep only the last 5 backups, delete older ones
# ls -t sort by newest first, tail -n +6 skips the first 5 (keep them),
# leaving only the old ones from 6th onward to be deleted

old_backups=$(ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6)

if [[ -n "$old_backups" ]]; then
 echo "Removing old backups:"
 for old in $old_backups; do
 echo "Deleting $old"
	 rm -f "$old"
 echo "No old backups to remove."
done
fi
	 
 echo "Backup process complete."
	 
