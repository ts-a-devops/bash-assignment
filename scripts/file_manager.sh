#!/bin/bash

LOG_FILE="logs/file_manager.log"

ACTION=$1
FILE1=$2
FILE2=$3

if [ "$ACTION" = "create" ]; then
    if [ -e "$FILE1" ]; then
      echo "File already exists."
else
 touch "$FILE1"
    echo "File created."
      echo "$(date): Created $FILE1" >> "$LOG_FILE"
fi

elif [ "$ACTION" = "delete" ]; then
rm -f "$FILE1"
    echo "File deleted."
      echo "$(date): Deleted $FILE1" >> "$LOG_FILE"

elif [ "$ACTION" = "list" ]; then

ls

elif [ "$ACTION" = "rename" ]; then
mv "$FILE1" "$FILE2"
     echo "File renamed."
       echo "$(date): Renamed $FILE1 to $FILE2" >> "$LOG_FILE"

else
    echo "Usage:"
     echo "./file_manager.sh create filename"
       echo "./file_manager.sh delete filename"
         echo "./file_manager.sh list"
           echo "./file_manager.sh rename old new"
fi
