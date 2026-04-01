#!bin/bash/

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/file_manager.log"

mkdir -p $LOG_DIR

ACTION=$1
FILE1=$2
FILE2=$3

log_action(){
	echo "$(date): $1" >> $LOG_FILE
}
 case $ACTION in
	 create)
		if [[ -z "$FILE1"]]; then
			echo "Error: Provide a file name"
			exit 1
		fi
		if [[ -f "$FILE1"]]; then
			echo "Error: File already exists!"
		else
			touch "$FILE1"
			echo "File created: $FILE1"
		fi
		;;
	delete)
		if [[ -f "$FILE1" ]]; then
			rm "$FILE1"
			echo "File deleted:$FILE1"
		else
			echo "Error: File does not exist"
		fi
		;;
	list)
		ls -lh
		;;
	rename)
		if [[ -f "$FILE1" && -n "$FILE2"]]; then
			if [[ -f "$FILE2"]]; then
				echo "Error: Target file already exist!"
			else
				mv "$FILE1" "$FILE2"
				echo "Renamed $FILE1 TO $FILE2"
			fi
		else
			echo "Error: Provide source and destination file"
		fi
		;;
	*)
		echo "Usage"
		echo "./file_manager.sh create <file>"
		echo "./file_manager.sh delete <file>"
		echo "./file_manager.sh list"
		echo "./file-manager.sh rename <oldd> <new>"
		;;
	esac


