#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/myfile_manager.log"

# Create logs directory if it doesn't exist
mkdir -p $LOG_DIR

action=$1
file1=$2
file2=$3

case $action in
   create)
       if [[ -f "$file1" ]]; then
           echo "File already exists!"
       else
           touch "$file1"
           echo "File created: $file1"
           echo "$(date): Created $file1" >> "$LOG_FILE"
       fi
       ;;

   delete)
       if [[ -f "$file1" ]]; then
           rm "$file1"
           echo "File deleted: $file1"
           echo "$(date): Deleted $file1" >> "$LOG_FILE"
       else
           echo "File not found!"
       fi
       ;;

   list)
	   if [[ "ls -A" ]];  then
	 echo "---current files---"
       ls
       echo "file listed"
       echo "$(date): file succesfully listed" >> "$LOG_FILE"
else
	echo "No files found" >> "$LOG_FILE"
	   fi
       ;;

   rename)
       if [[ -f "$file1" ]]; then
           mv "$file1" "$file2"
           echo "Renamed $file1 to $file2"
           echo "$(date): Renamed $file1 to $file2" >> "$LOG_FILE"
       else
           echo "File not found!"
       fi
       ;;

   *)
       
	  echo "Usage: $0 {create|delete|list|rename} filename [newname]"
       ;;
esac
