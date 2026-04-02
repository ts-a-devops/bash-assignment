#!/bin/bash

#save the current time in a variable
BACKUP_DATE=$(date "+%Y-%m-%d_%H-%M-%S")

#log action to this file path 
LOG_FILE="logs/backup/"
ACTIVITY_LOG="logs/backup/activity.log"

# Accept a directory as an input
read -p "Enter a directory: " ORIGINAL

#have a customized compressed name 
BACKED_FILE="$ORIGINAL.$BACKUP_DATE.tar.gz"

#Lets make the directory if it does not exist
mkdir -p "$LOG_FILE"

#check if the entered variable is a directory

#can be empty string
while [[ -z "$ORIGINAL" ]]; do
    read -p "Enter letters or numbers as directory: " ORIGINAL
done

#### so now we can check if it exist to compress

if [[ ! -d "$ORIGINAL" ]]; then
    
    echo "this directory does not exist"

    #Let also have a note for reference
    OUTPUT="$ORIGINAL does not exist"

    echo "$OUTPUT" | tee -a "$ACTIVITY_LOG"

    exit 1

else
    echo "$ORIGINAL directory exist"
    echo "Creating Backup"

    sleep 2

    tar -czvf "$LOG_FILE/$BACKED_FILE" "$ORIGINAL"

    #Let also have a note for reference
    OUTPUT="$ORIGINAL has been backed up"

    echo "$OUTPUT" | tee -a "$ACTIVITY_LOG"

fi 

#Keep only the last 2 Backups

COUNT=$(ls "$LOG_FILE" | wc -l)

if [[ "$COUNT" -gt 2 ]]; then 

    #if the number of items in logfile folder or backup folder is more than 2 then list the items according to their time and give me the olders from the end 
    DELETED_FILES=$(ls -1t "$LOG_FILE"/*.tar.gz | tail -n +3)

    #Now we can delete them 
    for f in $DELETED_FILES; do
        rm -r "$f"
        echo "deleting $f"
    done

    OUTPUT="Deleted Older Items"

    echo "$OUTPUT" >> "$ACTIVITY_LOG"
fi