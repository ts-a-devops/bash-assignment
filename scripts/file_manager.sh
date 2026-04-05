#!/bin/bash

LOG_FILE="../logs/file_manager.log"

action=$1
file=$2
new_name=$3

case $action in
  create)
    if [ -f "$file" ]; then
      echo "File already exists!" | tee -a $LOG_FILE
    else
      touch "$file"
      echo "Created $file" | tee -a $LOG_FILE
    fi
    ;;

  delete)
    if [ -f "$file" ]; then
      rm "$file"
      echo "Deleted $file" | tee -a $LOG_FILE
    else
      echo " File not found!" | tee -a $LOG_FILE
    fi
    ;;

  list)
    ls -l | tee -a $LOG_FILE
    ;;

  rename)
    if [ -f "$file" ]; then
      mv "$file" "$new_name"
      echo "Renamed $file to $new_name" | tee -a $LOG_FILE
    else
      echo "File not found!" | tee -a $LOG_FILE
    fi
    ;;

  *)
    echo "Invalid command" | tee -a $LOG_FILE
    ;;
esac
