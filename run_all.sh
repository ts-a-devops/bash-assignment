#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/app.log"

echo "1. System Check"
echo "2. Backup"
echo "3. Exit"

read -p "Choose: " choice

case $choice in
  1) ./scripts/system_check.sh ;;
  2)
    read -p "Directory: " dir
    ./scripts/backup.sh "$dir"
    ;;
  3) exit 0 ;;
esac

echo "$(date): Action $choice executed" >> "$LOG_FILE"
