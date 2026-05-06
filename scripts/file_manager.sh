#!/bin/bash

mkdir -p logs
LOG_FILE="logs/file_manager.log"

ACTION=$1
FILE=$2
TARGET=$3

echo "===== FILE MANAGER ACTION: $ACTION =====" | tee -a "$LOG_FILE"

case $ACTION in

create)
  if [ -f "$FILE" ]; then
    echo "Error: File '$FILE' already exists." | tee -a "$LOG_FILE"
  else
    touch "$FILE"
    echo "File '$FILE' created." | tee -a "$LOG_FILE"
  fi
  ;;

delete)
  if [ -f "$FILE" ]; then
    rm "$FILE"
    echo "File '$FILE' deleted." | tee -a "$LOG_FILE"
  else
    echo "Error: File not found." | tee -a "$LOG_FILE"
  fi
  ;;

list)
  echo "Listing files:" | tee -a "$LOG_FILE"
  ls -lh | tee -a "$LOG_FILE"
  ;;

rename)
  if [ -f "$FILE" ]; then
    mv "$FILE" "$TARGET"
    echo "Renamed '$FILE' to '$TARGET'." | tee -a "$LOG_FILE"
  else
    echo "Error: Source file not found." | tee -a "$LOG_FILE"
  fi
  ;;

*)
  echo "Usage: $0 {create|delete|list|rename}" | tee -a "$LOG_FILE"
  echo "Examples:" | tee -a "$LOG_FILE"
  echo "  $0 create file.txt" | tee -a "$LOG_FILE"
  echo "  $0 delete file.txt" | tee -a "$LOG_FILE"
  echo "  $0 list" | tee -a "$LOG_FILE"
  echo "  $0 rename old.txt new.txt" | tee -a "$LOG_FILE"
  ;;

esac
