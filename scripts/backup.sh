#!/bin/bash

mkdir -p logs backups

input_dir=$1

if [[ -z "$input_dir" ]]; then
    echo "Error: Provide a directory to backup."
    exit 1
fi

if [[ ! -d "$input_dir" ]]; then
    echo "Error: $input_dir does not exist."
    exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)
backup_file="backups/backup_$timestamp.tar.gz"

tar -czf "$backup_file" "$input_dir"
echo "Backup created: $backup_file"
echo "$(date): Backup created $backup_file" >> logs/backup.log

cd backups
ls -t | tail -n +6 | xargs -r rm --
echo "Old backups cleaned up."
