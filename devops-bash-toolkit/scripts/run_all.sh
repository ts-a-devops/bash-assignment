#!/bin/bash
set -eou pipefail
#variables
log="../logs/app.log"

while true; do
    echo "1. run_all.sh"
    echo "2. system check"
    echo "3. backup"
    echo "4. exit"
    read -p "choose from [1-4]: " c
    
    case $c in
        1) ./run_all.sh ;;
        2) ./system_check.sh ;;
        3) ./backup.sh ;;
        4) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done

