#!/bin/bash

mkdir -p logs
LOG_FILE="logs/vakouser_info.log"

#command prompt for username

read -p "What is your name?" NAME


#command prompt for age

read -p "How old are you?" AGE

#command prompt for country

read -p "What country are you from?" COUNTRY

#command to validate age numeric

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

