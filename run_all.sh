#!/bin/bash
set -euo pipefail

LOG="logs/app.log"

echo "1. Run All"
echo "2. System Check"
echo "3. Backup"
echo "4. Exit"

read -p "Choose option: " choice

case $choice in
  1)
    bash scripts/user_info.sh
    bash scripts/system_check.sh
    ;;
  2)
    bash scripts/system_check.sh
    ;;
  3)
    read -p "Enter directory: " dir
    bash scripts/backup.sh $dir
    ;;
  4)
    exit 0
    ;;
  *)
    echo "Invalid choice" | tee -a $LOG
    ;;
esac
