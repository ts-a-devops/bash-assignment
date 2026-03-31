#!/bin/bash

LOG_FILE="logs/file_manager.log"
mkdir -p logs

command=$1
file1=$2
file2=$3

case $command in
  create)
    if [[ -e "$file1" ]]; then
        echo "File already exists." | tee -a "$LOG_FILE"
    else
        touch "$file1"
        echo "File created: $file1" | tee -a "$LOG_FILE"
    fi
    ;;
  
  delete)
    if [[ -e "$file1" ]]; then
        rm "$file1"
        echo "File deleted: $file1" | tee -a "$LOG_FILE"
    else
        echo "File not found." | tee -a "$LOG_FILE"
    fi
    ;;

  list)
    ls -lh | tee -a "$LOG_FILE"
    ;;

  rename)
    if [[ -e "$file1" ]]; then
        mv "$file1" "$file2"
        echo "Renamed $file1 to $file2" | tee -a "$LOG_FILE"
    else
        echo "File not found." | tee -a "$LOG_FILE"
    fi
    ;;

  *)
    echo "Usage: $0 {create|delete|list|rename}" | tee -a "$LOG_FILE"
    ;;
esac
