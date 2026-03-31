#!/bin/bash

if [[ -d $1 ]]; then
   echo "$1 is a directory"
   tar -czvf "../backups/backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz" "$1" #archiving and compressing
   echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1 backup is created" &>> ../logs/backups.log #logging backup activity
   #backups folder to have only newest 5 backups
   cd ../backups/ || exit
   ls -1tr backup_*.tar.gz | head -n -5 | tee -a ../logs/backups.log | xargs -r rm -- 
else
    echo "$1 is not a directory"
fi
