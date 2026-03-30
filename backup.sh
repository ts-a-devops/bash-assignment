#!/bin/bash
mkdir -p ./backups
mkdir -p ./logs

if [[ -d "$1" ]]
then 
    tar -czf  ./backups/backup_"$(date +%H-%M-%S)".tar.gz "$1"
    echo "backup_"$(date +%H:%M:%S)" created successfully" | tee -a ./logs/backup.log
    count=$(ls -1 ./backups | wc -l)
    if [[ $count -gt 5 ]]
    then
        ls -1t ./backups/backup_*.tar.gz | tail -n +6 | xargs rm -rf
    fi
fi
