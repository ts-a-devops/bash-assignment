#!/bin/bash

# Interactive Menu for Bash Assignment

while true; do
	echo "================================"
	echo "     DEVOPS AUTOMATION MENU     "
	echo "================================"
	echo "1. Run System Check (Section B)"
	echo "2. Run File Manger (Section C)"
	echo "3. Run Directory Backup (Section D)"
	echo "4. Run Monitor Services (Section E)"
	echo "5. Exit"
	echo "================================"
	read -p "Enter your choice [1-5]: " choice

	case $choice in
		1)
			./system_check.sh
			;;
		2)
			read -p "Enter action(create/delete/list): " act
			read -p "Enter filename: " fname
			./file_manager.sh "$act" "$fname"
			;;
		3)
			read -p "Enter directory to backup: " dir
			./backup.sh "$dir"
			;;
		4)
			./process_monitor.sh
			;;
		5)
			echo "Exiting. Goodbye!"
			break
			;;
		*)
			echo "Invalid option. Please try again."
			;;
	esac 
	echo -e "\nPress Enter to return to menu..."
	read 
        done

