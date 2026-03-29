#!/bin/bash
log_action() {
	echo "$(date) - $1" >> logs/file_manager.log
}
#Creating the file
Main=$1
if [[ "$Main" == "create" ]]; then
	Newfile=$2
if [[ -f "$Newfile" ]]; then
		echo "Error! $Newfile already exists"
		log_action "CREATE ERROR: $Newfile already exists"
else
	touch "$Newfile"
	echo "$Newfile has been successfully created"
	log_action "CREATED: $Newfile"
fi
# Renaming the file
elif [[ "$Main" == "rename" ]]; then
	Oldfile=$2
	Newname=$3
if [[ -f "$Oldfile" ]]; then
	mv "$Oldfile" "$Newname"
	echo "$Oldfile has been renamed successfully to $Newname"
	log_action "RENAMED: $Oldfile to $Newname"
else
	echo "Error!!! $Oldfile does not exist"
	log_action "RENAME FAILED: $Oldfile not found"
fi
# Listing files in current working directory
elif [[ "$Main" == "list" ]]; then 
       echo "This is the list of all files in the present directory:"
       ls -l
       log_action "LISTED FILES"
# Deleting
elif [[ "$Main" == "delete" ]]; then
	Delfile=$2
if [[ -f "$Delfile" ]]; then
	rm "$Delfile"
	echo "$Delfile has been deleted successfully!"
	log_action "DELETED: $Delfile"
else
	echo "Error!! $Delfile does not exist to be removed"
	log_action "DELETE FAILED: $Delfile not found"
fi
fi



