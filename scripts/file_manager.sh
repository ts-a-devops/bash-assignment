#!/bin/bash


mkdir -p logs
LOG_FILE="logs/file_manager.log"
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

command="$1"
arg1="$2"
arg2="$3"

log_action() { 
	echo "[$timestamp] $1" >> "$LOG_FILE"
          }

case "$command" in create)
	            if [[ -z "$arg1" ]]; then
			echo "Usage: $0 create <filename>"
			exit 1
                     fi

		     if [[ -e "$arg1" ]]; then
			echo "Error: File '$arg1' already exists."
			log_action "Failed to create '$arg1' - file already exists."
			exit 1
		     fi

		     touch "$arg1"
		     echo "File '$arg1' created successfully."
		     log_action "Created file '$arg1'."
		     ;;

	     delete)
		if [[ -z "$arg1" ]]; then
		   echo "Usage: $0 delete <filename>"
		   exit 1
		fi

		if [[ ! -e "$arg1" ]]; then
	           echo "Error: File '$arg1' does not exist."
		   log_action "Failed to delete '$arg1' - file not found."
		   exit 1
		fi


		rm -f "$arg1"
		echo "file '$arg1' deleted successfully."
		log_action "Deleted file '$arg1'."
		;;


	list)
	    echo "Files in current directory."
	    ls -lh
	    log_action "Listed file in directory."
	    ;;


    rename)
	 if [[ -z "$arg1" || -z "$arg2" ]]; then
             echo "Usage: $0 rename <oldname> <newname>"
	     exit 1
	 fi


	 if [[ ! -e "$arg1" ]]; then
            echo "Error:File '$arg1' does not exist."
	    log_action "Failed to rename '$arg1' - file not found."
	    exit 1
	 fi



	 if [[ -e "$arg2" ]]; then
            echo "Error: File '$arg2' already exists. Cannot overwrite."
	    log_action "Failed to rename '$arg1' to '$arg2' - target exists."
	    exit 1
	 fi


	 mv "$arg1" "$arg2"
	 echo "File renamed from '$arg1' to '$arg2'."
	 log_action "Renamed file '$arg1' to '$arg2'."
	 ;;


        *)
         echo "Invalid command".
	 echo "Usage:"
	 echo "$0 create <filename>"
	 echo "$0 delete <filename>"
	 echo "list"
	 echo "$0 rename <oldname> <newname>"
	 exit 1
	 ;;
     esac
