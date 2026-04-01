#!/bin/bash

ACTION=$1
TARGET_FILE=$2
RENAME_FILE=$3

{

case $ACTION in	
	create)
		if [[ -e "$TARGET_FILE" ]]; then
			echo "The File already exsists."
		else
			echo "File created."
			touch "$TARGET_FILE"
	 	fi 
		;;
        delete)
                if [[ -e "$TARGET_FILE" ]]; then
			rm "$TARGET_FILE"
                        echo "The File is  deleted."
                else    
                        echo "The File doesn't exsist."
                fi
                ;;
       list)
              ls -la

	       ;;
       rename)
	       if [[ -e "$TARGET_FILE" ]] && [[ ! -e "$RENAME_FILE" ]]; then
                  mv "$TARGET_FILE" "$RENAME_FILE"
	       else
                        echo "$TARGET_FILE doesn't exsist or $RENAME_FILE already exsists"
                fi
                ;;
		*)
;;
esac
} | tee logs/file_manager_$(date +%F).log

