#!/bin/bash

LOG_FILE="logs/file_manager.log"
mkdir -p logs

ACTION=$1
FILE=$2
NEW_NAME=$3

case $ACTION in
  create)
    if [[ -f "$FILE" ]]; then
      echo "File already exists."
      exit 1
    fi
    touch "$FILE"
    echo "$(date) - Created $FILE" >> $LOG_FILE
    ;;

  delete)
    if [[ ! -f "$FILE" ]]; then
      echo "File does not exist."
      exit 1
    fi
    rm "$FILE"
    echo "$(date) - Deleted $FILE" >> $LOG_FILE
    ;;

  list)
    ls -lh
    echo "$(date) - Listed files" >> $LOG_FILE
    ;;

  rename)
    if [[ ! -f "$FILE" ]]; then
      echo "File does not exist."
      exit 1
    fi
    mv "$FILE" "$NEW_NAME"
    echo "$(date) - Renamed $FILE to $NEW_NAME" >> $LOG_FILE
    ;;

  *)
    echo "Usage: $0 {create|delete|list|rename} filename [new_name]"
    ;;
esac
