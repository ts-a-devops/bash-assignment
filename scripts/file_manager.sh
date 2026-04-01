#!/bin/bash

LOG_FILE="logs/file_manager.log"
command=$1
file=$2
newname=$3

# log action
log_action() {
	    echo "$(date): $1" >> $LOG_FILE
    }

    case $command in
	    create)
if [[ -z "$file" ]]; then
   echo "Error: filename required" | tee -a "$LOG_FILE"
   exit 1
fi

if [[ -e "$file" ]]; then
   echo "Error: file already exists" | tee -a "$LOG_FILE"
   log_action "CREATE FAILED: $file already exists"
   else
   touch "$file"
 echo "File created: $file" |  tee -a "$LOG_FILE"
   log_action "CREATED: $file"
fi
;;
delete)
if  [[ -z $file ]]; then
   echo "Error: filename required" |  tee -a "$LOG_FILE"
   exit 1
   fi
if [[ -e "$file" ]]; then
   rm "$file"
 echo "File deleted: $file" |  tee -a "$LOG_FILE"
 log_action "DELETED: $file"
else
 echo "Error: file not found" |  tee -a "$LOG_FILE"
  log_action "DELETE FAILED: $file not found"
  fi
  ;;

list)
ls
log_action "LISTED FILES"
;;

 rename)
if [[ -z "$file" ]] || [[ -z "$newname" ]]; then
   echo "Error: provide old and new filename" |  tee -a "$LOG_FILE"
				                 exit 1
		 fi
if [[ ! -e "$file" ]]; then
     echo "Error: file not found" |  tee -a "$LOG_FILE"
log_action "RENAME FAILED: $file not found"
elif [[ -e "$newname" ]]; then

	 echo "Error: new file name already exists" |  tee -a "$LOG_FILE"
         log_action "RENAME FAILED: $newname already exists"
     else
     mv "$file" "$newname"
    echo "Renamed $file to $newname"
 log_action "RENAMED: $file to $newname"
 fi
 ;;
 *)
       echo "Usage:"
       echo "./file_manager.sh {create|delete|list|rename} filename [newname]"
 ;;
 esac
