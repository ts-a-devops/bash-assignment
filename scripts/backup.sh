#!/bin/bash


DIR="$1"

if [ -d  $DIR ]
then
    echo "Directory exist"
    tar -czf backups/backup_$(date +%F).tar.gz $DIR
    echo "Backup of $DIR completed at $(date)" >> logs/backup.log
    cd backups/
    ls -t | tail -n +5 | xargs rm -f
    cd ..
else
    echo "Directory does not exist"
    exit 
fi


