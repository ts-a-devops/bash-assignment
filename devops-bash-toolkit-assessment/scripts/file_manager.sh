#!/bin/bash

# Support the following commands: create, delete, list, rename.
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/file_manager.log"
Filename="file.txt"
Filename1="filenew.txt"
case "$1" in
    create)
        if [[ -e "$Filename" ]] ; then
            echo "File already exist" | tee -a "$LOG_FILE"
	else
	    touch "$Filename"
            echo "Created $Filename"  | tee -a "$LOG_FILE"
        fi
        ;;
    delete)
	if [[ -e "$Filename" ]] ; then
            rm "$Filename"
            echo "Deleted $Filename"  | tee -a "$LOG_FILE"
        fi
        ;;
    list)
	ls
	    echo "listed files"    | tee -a "$LOG_FILE"
	;;
    rename)
	Filename="file.txt"
        Filename1="filenew.txt"
	touch "$Filename"  | tee -a "$LOG_FILE"
	if [[ ! -e $Filename ]] ; then
	    echo "file does not exist"
        elif [[ -e $Filename1 ]] ; then
            echo "File already exists. Cannot overwrite." | tee -a "$LOG_FILE"
        else
            mv "$Filename" "$Filename1"
            echo "Renamed $Filename to $Filename1"   | tee -a "$LOG_FILE"
        fi
	;;
    *)
        echo "Usage: $0 {create|delete|list|rename} [filename] [newname]"
        ;;
esac	

   
