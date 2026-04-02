#!/bin/bash

# To make a directory

dir="Learning"
if [[ -z "$dir" ]]; then
    echo "$dir: is a directory"
fi

# To check if a directory exists

if [[ ! -d "$dir" ]]; then
    echo "Yes, the directory exists."
fi

# Creating timestamp

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

#Creating a Backup filename

BACKUP_NAME="${dir}_backup_${TIMESTAMP}.tar.gz"

echo "Backup: $BACKUP_NAME"

tar -czf "$BACKUP" "$dir"


