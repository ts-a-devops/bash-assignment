#!/bin/bash

action=$1
file=$2
newname=$3

log_file="../logs/file_manager.log"

case $action in

  create)
    if [ -f "$file" ]; then
      echo "File already exists."
    else
      touch "$file"
      echo "File '$file' created."
      echo "$(date): Created $file" >> "$log_file"
    fi
    ;;

  delete)
    if [ -f "$file" ]; then
      rm "$file"
      echo "File '$file' deleted."
      echo "$(date): Deleted $file" >> "$log_file"
    else
      echo "File not found."
    fi
    ;;

  list)
    ls
    echo "$(date): Listed files" >> "$log_file"
    ;;

  rename)
    if [ -f "$file" ]; then
      mv "$file" "$newname"
      echo "Renamed '$file' to '$newname'."
      echo "$(date): Renamed $file to $newname" >> "$log_file"
    else
      echo "File not found."
    fi
    ;;

  *)
    echo "Usage:"
    echo "./file_manager.sh create filename"
    echo "./file_manager.sh delete filename"
    echo "./file_manager.sh list"
    echo "./file_manager.sh rename oldname newname"
    ;;
esac
