#!/bin/bash

set -euo pipefail

LOG_FILE="logs/app.log"
mkdir -p logs

run_all() {
  ./scripts/user_info.sh
  ./scripts/system_check.sh
}

run_system_check() {
  ./scripts/system_check.sh
}

run_backup() {
  echo "Enter directory to backup:"
  read dir
  ./scripts/backup.sh "$dir"
}

while true; do
  echo "1. Run All"
  echo "2. System Check"
  echo "3. Backup"
  echo "4. Exit"
  read choice

  case $choice in
    1)
      run_all
      ;;
    2)
      run_system_check
      ;;
    3)
      run_backup
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid option"
      ;;
  esac

  echo "$(date) - Action executed: $choice" >> $LOG_FILE
done
