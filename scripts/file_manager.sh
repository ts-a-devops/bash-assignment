#!/bin/bash

# Ensure logs folder exists
mkdir -p logs

# Log file path
LogFile="logs/file_manager.log"

# Step 3: Assign variables 
command=$1
file1=$2
file2=$3

#Case Statement

case "$command" in
	create)
		if [[ -z "$file1" ]]; then
			echo "No file name provided create" | tee -a "$LogFile"
			exit 1
		fi
		if [[ -f "$file1" ]]; then
			echo "File exists already" | tee -a "$LogFile"
		else
			touch "$file1"
			echo "Created $file1 on $(date)" | tee -a "$LogFile"
		fi
		;;
	delete)
		if [[ -z "$file1" ]]; then
			echo "No file name provided for delete" | tee -a "$LogFile"
			exit 1
		fi
		if [[ -f "$file1" ]]; then
			rm "$file1"
			echo "Deleted $file1 on $(date)" |  tee -a "$LogFile"
		else 
			echo "File does not exist" | tee -a "$LogFile"
		fi
		;;
	list)
		echo "List of files:" | tee -a "$LogFile"
		ls -lh | tee -a "$LogFile"
		;;
	rename)
		if [[ -z "$file1" || "$file2" ]]; then
			echo "Provide old and new file names for rename" | tee -a "$LogFile"
			exit 1
		fi
		if [[ -f "$file1" ]]; then
			mv "$file1" "$file2"
			echo "Renamed file $file1 to $file2 on $(date)" | tee -a "$LogFile"
		else
			echo "File does not exist" | tee -a "$LogFile"
		fi
		;;
	*)
		echo "Invalid command. Use: create delete, list, or rename."
		;;
esac

		

	







