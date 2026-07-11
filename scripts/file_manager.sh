#!/bin/bash

#This file creates, delete,list and rename files

exec > >(tee -a "logs/file_manager.log") 2>&1

command=$1  #$1= the first command
file=$2

case "$command" in
	create)
if [[ -e "$file" ]]; then  # -e checks if the file exists
    echo "Error: file exists"
else
	touch "$file"
	echo "created $file"
fi
;;

delete)
rm -v "$file"    # -v makes the file announce what it deleted
;;

list)
ls -l       # -l shows details (size, date, etc)
;;

rename)
 if [[ -e "$3" ]]; then 
	 echo "Error: $3 already exists"
 else
	 mv -v "$file" "$3"
fi

echo "Usage: ./file_manager.sh {create|delete|list|rename} file"

esac  #close the keyword "case"
