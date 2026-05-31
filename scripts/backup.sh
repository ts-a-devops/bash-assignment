#!/bin/bash
mkdir -p backups logs
log_file="logs/backup.log"
#check directory using -d
dir=$1
if [[ ! -d $dir ]]; then
    echo "therr is no such directory"
    echo "failed backup for $dir " >> $log_file
    exit 1
fi

#create a date time stamp
time= $(date + "%Y-%m-%d_%H-%M-%S")
#Backup name
backup_file="backups/backup_$time.tar.gz"
#create the backup itself
tar -czf "$backup_file" "$dir"
echo "back up created : $backup_file "
echo "created Backup for $dir " >> $log_file
# Keeping only the last 5 backup files
files= $(ls -t backups/backup_*.tar.gz)
count=0
for file in $files
do
    count=$((count+1))
    if [[ $count -gt 5 ]]; then
        rm -f "$file"
        echo "deleted old backup $file" >> $log_file
    fi
done

