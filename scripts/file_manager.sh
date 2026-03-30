#!/bin/bash
mkdir -p ./logs

case $1 in
	create)
        
	
        if [[ -e "$2"  ]]
	then
	    echo "$2 already exists" | tee -a ./logs/file_manager.log
        else
            touch $2
            echo -e "creating $2 ... \nDone" | tee -a ./logs/file_manager.log
        fi    
	
        ;;
        delete)
	if [[ -e "$2" ]]
	then
	    rm -rf $2 
	    echo -e " Deleting $2 ... \nDone" | tee -a ./logs/file_manager.log
	else
	    echo "File doesn't exist" | tee -a ./logs/file_manager.log
	fi
        ;;
        list)
	if [[ -e "$2" ]]
	then	
	    echo  "Listing $2 ..." | tee -a ./logs/file_manager.log
            ls -la $2
        else
	    echo "Cannot list $2 because it doesn't exist" | tee -a ./logs/file_manager.sh
        fi	
        ;; 
        rename)
	if [[ -e "$2" ]]
	then  	
	    mv $2 $3
	    echo -e "Renaming $2 to $3 .... \nDone" | tee -a ./log/file_manager.sh
	else
	    echo "File must exist before renaming" | tee -a ./log/file_manager.sh
	fi
esac	 
