#!/bin/bash

# Make logs folder
mkdir -p logs
LOG_FILE="logs/file_manager.log"

# Command and arguments
cmd=$1
file=$2
newfile=$3

# CREATE
if [ "$cmd" = "create" ]; then
  if [ -z "$file" ]; then
    echo "Provide a file name."
  elif [ -e "$file" ]; then
    echo "File already exists."
  else
    touch "$file"
    echo "Created $file"
    echo "$(date): Created $file" >> "$LOG_FILE"
  fi

# DELETE
elif [ "$cmd" = "delete" ]; then
  if [ -z "$file" ]; then
    echo "Provide a file name."
  elif [ ! -e "$file" ]; then
    echo "File does not exist."
  else
    rm "$file"
    echo "Deleted $file"
    echo "$(date): Deleted $file" >> "$LOG_FILE"
  fi

# LIST
elif [ "$cmd" = "list" ]; then
  ls
  echo "$(date): Listed files" >> "$LOG_FILE"

# RENAME
elif [ "$cmd" = "rename" ]; then
  if [ -z "$file" ] || [ -z "$newfile" ]; then
    echo "Provide old and new file names."
  elif [ ! -e "$file" ]; then
    echo "File does not exist."
  elif [ -e "$newfile" ]; then
    echo "Target file already exists."
  else
    mv "$file" "$newfile"
    echo "Renamed $file to $newfile"
    echo "$(date): Renamed $file to $newfile" >> "$LOG_FILE"
  fi

# HELP
else
  echo "Usage:"
  echo "./file_manager.sh create filename"
  echo "./file_manager.sh delete filename"
  echo "./file_manager.sh list"
  echo "./file_manager.sh rename oldname newname"
fi
