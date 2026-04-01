#!/bin/bash
#
log_dir="/home/eniiyi/bash-assignment/scripts/logs"
mkdir -p "$log_dir"

timestamp=$(date +"%Y_%m_%d %H_%M_%S")

backup="/home/eniiyi/bash-assignment/backups"

#make sure that directory backups exist
mkdir -p "$backup"

#create backup file path
backupfile="$backup/backup_$timestamp.tar.gz"

#read input form user
read -p "Enter a directory: " dir

#validate input as a directory
if [[ -d $dir ]]; then
	echo "valid directory"

#create compressed back up using "tar -c(create) z(.gz) f(file name flag) 
# "filename" "directory to be backed up"

	tar -czf "$backupfile" "$dir"
	echo ""

	echo "$timestamp - Backup created for $dir at $backupfile" >> "$log_dir/backup.log"

else echo "input a valid directory path"
fi

ls -t "$backup"/backup_*.tar.gz | tail -n +6 | while read old_backup; do
    rm "$old_backup"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - Deleted old backup: $old_backup" | tee "$log_dir/backup.log"
done
