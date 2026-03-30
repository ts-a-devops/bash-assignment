#!/bin/bash

Dir=$1

cd logs


if [[ -d $Dir ]]; then
    echo "Directory "${Dir}" exist" >> backup.log
else
    echo "Directory "${Dir}" does not exist" >> backup.log
fi

tar -czvf backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz "$Dir"
echo "Compressed backup created" >> backup.log

ls -1t backups/backup_*.tar.gz | tail -n +6 | xargs -r rm --
echo "Reserved: Top 5 Backups" >> backup.log