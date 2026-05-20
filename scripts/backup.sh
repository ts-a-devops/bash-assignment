#!/bin/bash

read -p "Enter directory to backup: " dir

# Validate directory exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory '$dir' does not exist."
    exit 1
fi

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backup_${DATE}.tar.gz"

tar -czf "$BACKUP_FILE" "$dir"
echo "Backup created: $BACKUP_FILE"
