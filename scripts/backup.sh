#!/bin/bash
 
BACKUPS_FILENAME="backups"
LOG_FILE="logs/backup.log"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)

#Create the backups folder
mkdir -p "$BACKUPS_FILENAME"

#Command to accept a directory as input
read -p "Create a directory with this name: " DIRECTORY

#Command to validate that the directory exists
if [[ -d "$DIRECTORY" ]]; then
    echo "Error: '$DIRECTORY' already exists, Cannot Overwrite"

else
mkdir "$DIRECTORY"
    echo "Created Directory '$DIRECTORY' Successfully"
fi

#Command to create the compressed backup
BACKUP_FILE="$BACKUPS_FILENAME/backup_${TIMESTAMP}.tar.gz"

#Command to create the tar file and store them in backups
tar -czvf "$BACKUP_FILE" "$DIRECTORY"

#Command to keep only the last 5 backups and delete older backups
cd "$BACKUPS_FILENAME" && ls -t  | tail -n +6 | xargs rm -f && cd ..

echo "Successfully backed up '$DIRECTORY' to '$BACKUP_FILE'" >> "$LOG_FILE"
