#!/bin/bash
set -euo pipefail

LOG_FILE="./logs/app.log"

run_all() {
  ./scripts/user_info.sh
  ./scripts/system_check.sh
  ./scripts/backup.sh
}

while true; do
  echo "1. Run All"
  echo "2. System Check"
  echo "3. Backup"
  echo "4. Exit"

  read -p "Choose option: " choice

  case $choice in
    1)
      run_all
      ;;
    2)
      ./scripts/system_check.sh
      ;;
    3)
      ./scripts/backup.sh
      ;;
    4)
      exit 0
      ;;
    *)
      echo "Invalid option"
      ;;
  esac

  echo "$(date): User selected option $choice" >> "$LOG_FILE"
done
