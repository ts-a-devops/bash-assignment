#!/bin/bash

mkdir -p logs
LOG_FILE="logs/myuser_info.log"

#command to prompt user for Name

read -p "what is your Name?" NAME 

#command to prompt user for Age

read -p "what is your Age?" AGE

#command to prompt user for Country

read -p "what is your Country?" COUNTRY

#command to validate Age is numeric

if [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Validation successful. Age is "$AGE"."
else
    echo "Error: Age must be a numeric value." 
    exit 1
fi

#Age category

if [[ "$AGE" -lt 18 ]]; then CAT="A minor"

elif
	[[ "$AGE" -ge 18 ]] && [[ "$AGE" -le 65 ]]; then CAT="An adult"
else
	CAT="A senior"
fi

#output message
echo "You are welcome $NAME From $COUNTRY, you are $AGE and $CAT please enjoy your stay!!"

#saving to log file
echo "You are welcome $NAME From $COUNTRY, you are $AGE and $CAT please enjoy your stay!!" >> "$LOG_FILE"
