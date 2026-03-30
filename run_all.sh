#!/bin/bash

set -euo pipefail

mkdir -p logs
log_file="logs/app.log"

run_all() {
  echo "Running all scripts..." | tee -a "$log_file"

  ./scripts/user_info.sh
  ./scripts/system_check.sh
  ./scripts/backup.sh scripts

  echo "All scripts executed successfully" | tee -a "$log_file"
}

system_check() {
  echo "Running system check..." | tee -a "$log_file"
  ./scripts/system_check.sh
}

backup() {
  echo "Running backup..." | tee -a "$log_file"
  ./scripts/backup.sh scripts
}

while true; do
  echo ""
  echo "===== DevOps Toolkit Menu ====="
  echo "1. Run All"
  echo "2. System Check"
  echo "3. Backup"
  echo "4. Exit"

  read -p "Choose an option: " choice

  case $choice in
    1) run_all ;;
    2) system_check ;;
    3) backup ;;
    4) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid option" ;;
  esac
done
