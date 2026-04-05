#!/bin/bash

LOG_FOLDER="logs"
LOG_FILE="$LOG_FOLDER/file_manager.log"

# create folder if it does not exist
cd ..
mkdir -p "$LOG_FOLDER"

echo "=== File Management ===" | tee -a "$LOG_FOLDER"

action=$1
file=$2

case "$action"	in
    "create")
         if [[ -f "$file"  ]]; then
              echo "File already exist!" | tee -a "$LOG_FILE"
         else
              touch "$file"
              echo " $file successfully created" | tee -a "$LOG_FILE"
         fi
    ;;
    "delete")
         if [[ -f "$file" ]]; then
              rm "$file"
              echo "$file successfully deleted" | tee -a "$LOG_FILE"
         else
              echo "File not found" | tee -a "$LOG_FILE"
         fi
    ;;
    "list")
         ls | tee -a "$LOG_FILE"
    ;;
    "rename")
         new_file=$3
         if [[ -f "$file"  ]]; then
              mv "$file" "$new_file"
              echo "File successfully renamed to $new_file" | tee -a "$LOG_FILE"
         else
              echo "File not found" | tee -a "$LOG_FILE"
         fi
    ;;
    *)
    echo "Usage: $0 {create|delete|list|rename} filename filename?" | tee -a "$LOG_FILE"
    ;;
esac
