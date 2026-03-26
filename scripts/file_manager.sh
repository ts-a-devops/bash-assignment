#!/bin/bash

mkdir -p logs

log_file="logs/file_manager.log"

command="$1"
target="$2"
new_name="$3"

case "$command" in
  create)
    if [ -z "$target" ]; then
      echo "Please provide a file name."
    elif [ -e "$target" ]; then
      echo "File already exists. Will not overwrite."
      echo "$(date): create failed for $target" >> "$log_file"
    else
      touch "$target"
      echo "File $target created successfully."
      echo "$(date): created $target" >> "$log_file"
    fi
    ;;
  delete)
    if [ -z "$target" ]; then
      echo "Please provide a file name."
    elif [ -e "$target" ]; then
      rm "$target"
      echo "File $target deleted successfully."
      echo "$(date): deleted $target" >> "$log_file"
    else
      echo "File does not exist."
      echo "$(date): delete failed for $target" >> "$log_file"
    fi
    ;;
  list)
    ls
    echo "$(date): listed files" >> "$log_file"
    ;;
  rename)
    if [ -z "$target" ] || [ -z "$new_name" ]; then
      echo "Please provide the old and new file names."
    elif [ ! -e "$target" ]; then
      echo "File does not exist."
      echo "$(date): rename failed for $target" >> "$log_file"
    elif [ -e "$new_name" ]; then
      echo "Target name already exists. Cannot overwrite."
      echo "$(date): rename failed because $new_name exists" >> "$log_file"
    else
      mv "$target" "$new_name"
      echo "File renamed from $target to $new_name successfully."
      echo "$(date): renamed $target to $new_name" >> "$log_file"
    fi
    ;;
  *)
    echo "Usage:"
    echo "./scripts/file_manager.sh create <filename>"
    echo "./scripts/file_manager.sh delete <filename>"
    echo "./scripts/file_manager.sh list"
    echo "./scripts/file_manager.sh rename <oldname> <newname>"
    ;;
esac
