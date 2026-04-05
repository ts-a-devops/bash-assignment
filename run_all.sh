#!/bin/bash
set -euo pipefail

LOG_FILE="logs/app.log"

while true; do
  echo "1. Run all"
  echo "2. System check"
  echo "3. Backup"
  echo "4. Exit"

  read -p "Choose option: " choice

  case $choice in
    1)
      ./scripts/user_info.sh
      ./scripts/system_check.sh
      echo "Ran all scripts" >> $LOG_FILE
      ;;
    2)
      ./scripts/system_check.sh
      ;;
    3)
      read -p "Enter directory to backup: " dir
      ./scripts/backup.sh $dir
      ;;
    4)
      exit 0
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
done
