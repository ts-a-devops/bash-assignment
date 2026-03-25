#!/bin/bash

### log the file here to a document

LOG_FILE="logs/app.log"


##### Create this file
mkdir -p logs

### exit if there is undefined error or unordered command
set -euo pipefail

## Create a function that runs the script and is reusable

run_script() {
    SCRIPT_PATH="$1" #argument and path to the script
    SCRIPT_NAME="$2" #script name as argument 2

    #first notify us in the terminal and log it in the log file

    echo "$SCRIPT_NAME is running" | tee -a "$LOG_FILE"
    
    #we need to check if the bash script was successgul or failed and store it in our file

    if bash "$SCRIPT_PATH"; then 
        echo "$SCRIPT_NAME script finished" | tee -a "$LOG_FILE"
    else
        echo "$SCRIPT_NAME script failed" | tee -a "$LOG_FILE"
    fi
}


###calling the script from the directry and storing it in a fil

##Whenever we call run script function above always add the argument 1 and 2 because they are declared within the variable

run_all() {
        #call the run script function here and attach argument 1 and 2
    run_script "./scripts/user_info.sh" "userinfo"
    run_script "./scripts/system_check.sh" "System_Check"
    run_script "./scripts/backup.sh" "Backup_Directory"
    run_script "./scripts/file_manager.sh" "File_Manager"

}

system_check() {
    #Add the runscript function for back up directory
   run_script "./scripts/system_check.sh" "System Check"
}

backup_dir() {
    run_script "./scripts/backup.sh" "Backup Directory"
}


##menu Interaction  we will use a while loop

while true; do
    echo "Welcome to an Interactve menu: "
    echo "1. Run all Script"
    echo "2. Do a system check"
    echo "3. Create a Backup Folder"
    echo "4. Exit"

    read -p "Choose an option number e.g (1 for run all script, 2 for DO a system check): " VALUE

    case $VALUE in
        1)
            run_all
        ;;

        2) 
            system_check
        ;;

        3)
            backup_dir
        ;;

        4)
            echo "you are now exiting interaction....."
            exit 0
        ;;

        *)
            echo "this is an invalid entry"
        ;;

    esac
done 

