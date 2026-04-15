#!/bin/bash

# Correctly define the log file path
LOG="logs/system_report_$(date +%Y%m%d_%H%M).log"
mkdir -p logs

# Assign argument to readable variables 
action=$1
file1=$2
file2=$3

# Stops the scripts if the filename ($file1)is missing
if [ -z "$file1" ] && [ "$action" != "list" ]; then
	echo "Error: Missing filename: ./file_manager.sh create [filename]"
	exit 1
fi

case $action in
	"create")
		# check if file already exists to prevent overwriting 
		if [ -f "$file1" ]; then
			echo "Error: $file1 already exist." | tee -a "$LOG"
			else 
				touch "$file1"
				echo "$(date): Created $file1" >> "$LOG"
				echo "File '$file' created."
		fi
		;;
		
	"delete")
		if [ -f "$file1" ]; then 
			rm "$file1"
			echo "$(date): Deleted $file1" >> "$LOG"
			echo " File '$file1' deleted."
		else
			echo "Error: '$file1' does not exist." | tee -a "$LOG"
		fi
		;;

	"list")
		echo "$(date): Listed directory contents" >> "$LOG"
		ls -lh
		;;

	"rename")
		if [ -f "$file1" ]; then
			mv "$file1" "$file2"
			echo "$(date): Renamed $file1 to $file2" >> "$LOG"
			 echo "Renamed $file1 to $file2."
		 else 
			 echo "Error: Source file '$file1' not found." | tee -a "$LOG"
		fi
		;;

	*)
		echo "Usage: $0 {create|delete|list|rename} [filename] [new_filename]"
		;;
esac


