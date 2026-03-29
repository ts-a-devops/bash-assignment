#!/bin/bash

LOG_FILE="../logs/file_manager.log"

action=$1
file=$2
new_name=$3

case $action in
  create)
    if [[ -f "$file" ]]; then
      echo "File already exists!"
    else
      touch "$file"
      echo "File created: $file"
      echo "$(date): Created $file" >> "$LOG_FILE"
    fi
    ;;

  delete)
    if [[ -f "$file" ]]; then
      rm "$file"
      echo "File deleted: $file"
      echo "$(date): Deleted $file" >> "$LOG_FILE"
    else
      echo "File not found!"
    fi
    ;;

  list)
    ls -l
    echo "$(date): Listed files" >> "$LOG_FILE"
    ;;

  rename)
    if [[ -f "$file" ]]; then
      mv "$file" "$new_name"
      echo "File renamed to $new_name"
      echo "$(date): Renamed $file to $new_name" >> "$LOG_FILE"
    else
      echo "File not found!"
    fi
    ;;

  *)
    echo "Usage: $0 {create|delete|list|rename} filename [new_name]"
    ;;
esac
