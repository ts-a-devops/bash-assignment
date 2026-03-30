#!/bin/bash

mkdir -p logs

log_file="logs/file_manager.log"

action=$1
file1=$2
file2=$3

case "$action" in

  create)
    if [[ -z "$file1" ]]; then
      echo "Error: No filename provided"
      exit 1
    fi

    if [[ -f "$file1" ]]; then
      echo "File already exists"
    else
      touch "$file1"
      echo "File '$file1' created"
      echo "$(date): Created $file1" >> "$log_file"
    fi
    ;;

  delete)
    if [[ -f "$file1" ]]; then
      rm "$file1"
      echo "File '$file1' deleted"
      echo "$(date): Deleted $file1" >> "$log_file"
    else
      echo "File does not exist"
    fi
    ;;

  list)
    ls -l
    echo "$(date): Listed files" >> "$log_file"
    ;;

  rename)
    if [[ -f "$file1" ]]; then
      mv "$file1" "$file2"
      echo "Renamed '$file1' to '$file2'"
      echo "$(date): Renamed $file1 to $file2" >> "$log_file"
    else
      echo "File does not exist"
    fi
    ;;

  *)
    echo "Usage: $0 {create|delete|list|rename} filename [newname]"
    exit 1
    ;;

esac
