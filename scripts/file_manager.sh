#!/bin/bash

LOG_FILE="logs/file_manager.log"
mkdir -p logs

action=$1
file1=$2
file2=$3

echo "Action: $action"

case $action in

  create)
    if [ -z "$file1" ]; then
      echo "Error: No filename provided"
    elif [ -f "$file1" ]; then
      echo "Error: File already exists"
    else
      touch "$file1"
      echo "$(date): Created $file1" >> "$LOG_FILE"
      echo "File created: $file1"
    fi
    ;;

  delete)
    if [ -f "$file1" ]; then
      rm "$file1"
      echo "$(date): Deleted $file1" >> "$LOG_FILE"
      echo "File deleted: $file1"
    else
      echo "Error: File does not exist"
    fi
    ;;

  list)
    echo "Files in current directory:"
    ls
    echo "$(date): Listed files" >> "$LOG_FILE"
    ;;

  rename)
    if [ -z "$file1" ] || [ -z "$file2" ]; then
      echo "Error: Provide source and new name"
    elif [ ! -f "$file1" ]; then
      echo "Error: File does not exist"
    elif [ -f "$file2" ]; then
      echo "Error: Cannot overwrite existing file"
    else
      mv "$file1" "$file2"
      echo "$(date): Renamed $file1 to $file2" >> "$LOG_FILE"
      echo "File renamed to $file2"
    fi
    ;;

  *)
    echo "Usage:"
    echo "./file_manager.sh create <filename>"
    echo "./file_manager.sh delete <filename>"
    echo "./file_manager.sh list"
    echo "./file_manager.sh rename <oldname> <newname>"
    ;;

esac