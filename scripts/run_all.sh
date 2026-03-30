
#!/bin/bash

set -euo pipefail

BASE_DIR="$(dirname "$0")"  # directory where run_all.sh lives
REPO_DIR="$(realpath "$BASE_DIR/..")"  # repo root

while true; do
    echo "1. Run system check"
     echo "2. Run backup"
      echo "3. Run all"
       echo "4. Exit"

read choice
choice=$(echo $choice | tr -d '"')  # remove quotes

if [ "$choice" = "1" ]; then
"$REPO_DIR/scripts/system_check.sh"
elif [ "$choice" = "2" ]; then
    echo "Enter directory to backup:"
read dir
"$REPO_DIR/scripts/backup.sh" "$dir"
elif [ "$choice" = "3" ]; then
"$REPO_DIR/scripts/system_check.sh"
   echo "Enter directory to backup:"
read dir
"$REPO_DIR/scripts/backup.sh" "$dir"
elif [ "$choice" = "4" ]; then
   echo "Goodbye"
exit 0
else
   echo "Invalid option"
fi
 done
