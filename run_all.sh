#!/bin/bash

while true
do
    echo "1. Run system check"
    echo "2. Run backup"
    echo "3. Exit"

    read choice

    case $choice in
        1) ./scripts/system_check.sh ;;
        2) ./scripts/backup.sh scripts ;;
        3) exit ;;
        *) echo "Invalid" ;;
    esac
done
