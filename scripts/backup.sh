#!/bin/bash

# 1. Define where the files are and where the backup goes
SOURCE="my_files"
DESTINATION="backups"

# 2. Create a timestamp (Year-Month-Day_Hour-Minute)
# This makes every backup name unique!
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

# 3. Create the backup filename
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"

echo "Starting backup of $SOURCE..."

# 4. Check if the source folder actually exists
if [ -d "$SOURCE" ]; then
    # Create a compressed 'tar' file of the folder
    tar -czf "$DESTINATION/$BACKUP_NAME" "$SOURCE"
    echo "Backup successful! Saved as $DESTINATION/$BACKUP_NAME"
else
    echo "Error: Source folder '$SOURCE' not found. Run file_manager.sh first!"
    exit 1
fi

# 5. List the backup folder to confirm it worked
ls -lh "$DESTINATION"