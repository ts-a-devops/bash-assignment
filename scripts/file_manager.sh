#!/bin/bash

# ==========================================
# Script: file_manager.sh
# Description: Basic file operations tool
# Author: David Igbo
# ==========================================

mkdir -p ../logs
LOG_FILE="../logs/file_manager.log"

show_help() {
  echo "======================================"
  echo " FILE MANAGER TOOL"
  echo "======================================"
  echo "Usage:"
  echo "  ./file_manager.sh create <filename>"
  echo "  ./file_manager.sh delete <filename>"
  echo "  ./file_manager.sh list"
  echo "  ./file_manager.sh rename <old_name> <new_name>"
  echo "  ./file_manager.sh help"
  echo "======================================"
}

action=$1
file=$2
new_name=$3

# Show help if no arguments or help requested
if [[ -z "$action" || "$action" == "help" ]]; then
  show_help
  exit 0
fi

# Validate required arguments per action
case $action in
  create|delete)
    if [[ -z "$file" ]]; then
      echo "Error: filename is required"
      show_help
      exit 1
    fi
    ;;

  rename)
    if [[ -z "$file" || -z "$new_name" ]]; then
      echo "Error: old and new filenames are required"
      show_help
      exit 1
    fi
    ;;
esac

case $action in
  create)
    if [[ -f "$file" ]]; then
      echo "File already exists!"
    else
      touch "$file"
      echo "File created: $file"
      echo "$(date '+%Y-%m-%d %H:%M:%S'): Created $file" >> "$LOG_FILE"
    fi
    ;;

  delete)
    if [[ -f "$file" ]]; then
      rm "$file"
      echo "File deleted: $file"
      echo "$(date '+%Y-%m-%d %H:%M:%S'): Deleted $file" >> "$LOG_FILE"
    else
      echo "File does not exist!"
    fi
    ;;

  list)
    ls -l
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Listed files" >> "$LOG_FILE"
    ;;

  rename)
    if [[ -f "$file" ]]; then
      if [[ -f "$new_name" ]]; then
        echo "Error: Target file already exists!"
        exit 1
      fi

      mv "$file" "$new_name"
      echo "File renamed to $new_name"
      echo "$(date '+%Y-%m-%d %H:%M:%S'): Renamed $file to $new_name" >> "$LOG_FILE"
    else
      echo "File not found!"
    fi
    ;;

  *)
    echo "Invalid option!"
    show_help
    exit 1
    ;;
esac

exit 0
