#!/bin/bash

LOG_FILE="../logs/file_manager.log"
ACTION=$1
FILE=$2

case "$ACTION" in
  create)
      if [[ -f "$FILE" ]]; then
           echo "File already exists!" | tee -a "$LOG_FILE"
         else
            touch "$FILE"
           echo "File created: $FILE" | tee -a "$LOG_FILE"
      fi
        ;;
       delete)

     if [[ -f "$FILE" ]]; then
        rm "$FILE"
        echo "File deleted: $FILE" | tee -a "$LOG_FILE"
      else
        echo "File not found!" | tee -a "$LOG_FILE"
     fi
       ;;

       list)
     ls -lh | tee -a "$LOG_FILE"
       ;;

       rename)
       NEW_NAME=$3
       if [[ -f "$FILE" ]]; then
       mv "$FILE" "$NEW_NAME"
      echo "Renamed $FILE to $NEW_NAME" | tee -a "$LOG_FILE"
          else
         echo "File not found!" | tee -a "$LOG_FILE"
      fi
      ;;
      *)
      echo "Usage: $0 {create|delete|list|rename} filename filename?" | tee -a "$LOG_FILE"
      ;;
esac
