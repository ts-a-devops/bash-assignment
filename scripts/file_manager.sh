#!/bin/bash

ACTION=$1
FILE=$2
LOG="logs/file_manager.log"

case $ACTION in
  create)
    if [ -f "$FILE" ]; then
      echo "File already exists!" | tee -a $LOG
    else
      touch "$FILE"
      echo "File created: $FILE" | tee -a $LOG
    fi
    ;;
  
  delete)
    rm -f "$FILE"
    echo "File deleted: $FILE" | tee -a $LOG
    ;;
  
  list)
    ls
    ;;
  
  rename)
    NEWNAME=$3
    mv "$FILE" "$NEWNAME"
    echo "Renamed $FILE to $NEWNAME" | tee -a $LOG
    ;;
  
  *)
    echo "Usage: create|delete|list|rename"
    ;;
esac
