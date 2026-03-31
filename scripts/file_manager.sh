#!/bin/bash

case $1 in
   "create")
      if [ -f "$2" ]; then
         echo "$(date) - CREATE - $2 - FAILURE. File already exists " 2>&1 | tee -a logs/file_manager.log
      else 
         touch "$2"
         echo "$(date) - CREATE - $2 - SUCCESS" 2>&1 | tee -a logs/file_manager.log
      fi
      ;;

   "delete")
      if [ -f "$2" ]; then
         rm "$2"
         echo "$(date) - DELETE - $2 - SUCCESS" 2>&1 | tee -a logs/file_manager.log
      else 
         echo "$(date) - DELETE - $2 - FAILURE. No file named $2 exists" 2>&1 | tee -a logs/file_manager.log
      fi
      ;;

   "list") 
      if [ -d "$2" ]; then
         ls -l "$2"
         echo "$(date) - LIST - $2 - SUCCESS" 2>&1 | tee -a logs/file_manager.log
      else 
         echo "$(date) - LIST - $2 - FAILURE. Directory does not exist" 2>&1 | tee -a logs/file_manager.log     
      fi
      ;;
  
   "rename")
      if [ -f "$2" ]; then
         mv $2 $3
         echo "$(date) - RENAME - $2 TO $3 - SUCCESS" 2>&1 | tee -a logs/file_manager.log
      else 
         echo "$(date) - RENAME - FAILURE - $2 does not exist" 2>&1 | tee -a logs/file_manager.log
      fi
      ;;
    
   *)
    echo "$(date) - UNKNOWN COMMAND. VALID INPUTS: CREATE, DELETE, LIST OR RENAME" 2>&1 | tee -a logs/file_manager.log

esac
