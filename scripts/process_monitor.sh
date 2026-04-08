#!/bin/bash

# Log file
LOG_FILE="logs/process_monitor.log"
mkdir -p logs

# Array of allowed services
services=("nginx" "ssh" "docker")

# Ask for process input
read -p "Enter a process name: " PROC

# Validate input
### ^[a-zA-Z]+$ begining of the string ^ and end of string +$ the PROC value has to contain strings; the reason for this i know what is in my array-services
#### if my array has other variables apart from string values then i can set the regex value to be include numbers ^[0-9a-zA-Z]+$ and this account for numbers or to account for special characters in the array ^[0-9a-zA-Z-_]+$

while [[ -z "$PROC" || ! "$PROC" =~ ^[a-zA-Z]+$ ]]; do
## this while loop says while PROC is empty or PROC does not contain a string ask for a valid key namee

    read -p "Enter a valid process name (letters only): " PROC
done

# TO check if input is in the array I will seit to falso or 0 (to compare with)
FOUND=false
#also you can set FOUND=0 also just need to set it 1 for true and false when FOUND != "1"

###loop through the array
for search in "${services[@]}"; do    

        #check if the input matches with the array words
    if [[ "$PROC" == "$search" ]]; then
        
        #find the item stored as input is seen in the array
        ###if i see a word
        FOUND=true

        # Check if process is running

        #if it is running then
        if pgrep -x "$PROC" > /dev/null; then
            STATUS="Running"
            echo "$PROC is $STATUS" | tee -a "$LOG_FILE"
        else
            #if it is not running 
            STATUS="Stopped"
            echo "$PROC is $STATUS" | tee -a "$LOG_FILE"


            #we ask for it to be restarted, requesting for user input:

            read -p "Do you want to restart $PROC? (yes/no): " VALUE
            
            #we are checkiing the input must be strictly yes or no if not then enter the value again

            while [[ "$VALUE" != "yes" && "$VALUE" != "no" ]]; do
            ### while the restart value is NOT yes and NOT no then we ask again for user to re enter

                read -p "Input either yes or no: " VALUE
            done

            #if we are satisfied with the value

            if [[ "$VALUE" == "yes" ]]; then
                echo "Restarting $PROC..." | tee -a "$LOG_FILE"
                sudo systemctl start "$PROC"

                    #check if it restarted again
                if pgrep -x "$PROC" > /dev/null; then
                    STATUS="Restarted"
                    echo "$PROC has been $STATUS" | tee -a "$LOG_FILE"
                else

                #if it did not restart
                    STATUS="Failed to restart"
                    echo "$PROC $STATUS" | tee -a "$LOG_FILE"
                fi
            else

            #if value was entered as "no"
                echo "Not restarting $PROC" | tee -a "$LOG_FILE"
            fi
        fi
        # we are done with the process checks then stop - so we have found a match stop if we dont find a match then FOUND=false on default
        break
    fi
done

#### so this executes after the loop and we dont assign FOUND=true so hence this takes place
if [[ "$FOUND" == false ]]; then
    echo "$PROC is not in the monitored services list" | tee -a "$LOG_FILE"
fi