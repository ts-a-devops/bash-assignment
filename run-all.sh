#!/bin/bash

set -euo pipefail

mkdir -p logs

echo "1: Run all"
echo "2: System Check"
echo "3: Backup"
echo "4: Exit"

read -p "Select your choice: " choice 

case $choice in 
1)
./scripts/user_info.sh
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
echo "Invalid choice"
esac

echo "$(date): Ran option $choice" >> logs/app.log





