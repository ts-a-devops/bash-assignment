#!/bin/bash

# Ensure required directories exist
mkdir -p backups logs

# Log file path
LOG_FILE="logs/backup.log"

# Input directory to back up
DIR=$1

# Check if directory argument is provided
if [[ -z "$DIR" ]]; then
    echo "Provide a directory to back up."
    exit 1
fi

# Validate that directory exists
if [[ ! -d "$DIR" ]]; then
    echo "Directory does not exist."
    exit 1
fi

# Generate timestamp for unique backup filename
TIMESTAMP=$(date +%F-%H-%M-%S)

# Define backup file path
BACKUP_FILE="backups/backup_$TIMESTAMP.tar.gz"

# Create compressed archive using tar
tar -czf "$BACKUP_FILE" "$DIR"

# Notify user
echo "Backup created: $BACKUP_FILE"

# Log the backup activity
echo "$(date): Backup created: $BACKUP_FILE" >> "$LOG_FILE"

# Keep only the most recent 5 backups
cd backups || exit

# List files sorted by newest, remove older ones
ls -t | tail -n +6 | xargs -r rm --

# Log cleanup activity
echo "$(date): Old backups cleaned" >> "../$LOG_FILE"
