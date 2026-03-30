#!/bin/bash
# file_manager.sh - Simple file management operations

LOG_FILE="logs/file_manager.log"
mkdir -p logs

action=$1
file1=$2
file2=$3

case "$action" in
	create)
		if [ -e "$file1" ]; then
			echo "File $file1 already exists!" | tee -a "$LOG_FILE"
		else
			touch "$file1"
			echo "Created file $file1" | tee -a "$LOG_FILE"
		fi
		;;
	delete)
		if [ -e "$file1" ]; then
			rm "$file1"
			echo "Deleted file $file1" | tee -a "$LOG_FILE"
		else
			echo "File $file1 does not exist!" | tee -a "$LOG_FILE"
		fi
		;;
	list)
		ls -l | tee -a "$LOG_FILE"
		;;
	rename)
		if [ -e "$file1" ]; then
			mv "$file1" "$file2"
			echo "Renamed $file1 to $file2" | tee -a "$LOG_FILE"
		else
			echo "File $file1 does not exist!" | tee -a "$LOG_FILE"
		fi
		;;
	*)
		echo "Usage: $0 {create|delete|list|rename} file [new_name]"
		;;
esac
