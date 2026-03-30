#!/usr/bin/env bash
set -euo pipefail

mkdir -p logs

echo "1. Run all"
echo "2. System check"
echo "3. Backup"
echo "4. Exit"

read -p "Choose option: " choice

case $choice in
1)
./scripts/system_check.sh
;;
2)
./scripts/system_check.sh
;;
3)
read -p "Enter directory: " dir
./scripts/backup.sh "$dir"
;;
4)
exit 0
;;
*)
echo "Invalid option"
;;
esac