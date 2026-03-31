#!/bin/bash

LOG_FILE="../logs/user_info.log"

read -p "What is your name?" name
read -p "How old are you?" age
read -p "What country are you from?" country

#Validate inputs
if [[ -z ${name} || -z ${age} || -z ${country} ]]; then
	echo "Error: Please fill in all fields" | tee -a "${LOG_FILE}"
	exit 1 
        fi

        if ! [[ "$age" =~ ^[0-9]+$ ]]; then
	      echo "Error: Age must be numeric" | tee -a "${LOG_FILE}"
 	      exit 1 
	fi

if (( ${age} < 18 )); then 
	    category="Minor"
    elif (( ${age} <= 65 )); then
	    category="Adult"
    else
	    category="Senior"
            fi

# Final Output Message
message="Hello ${name} from ${country}. You are categorized as ${category}."
echo "${message}" | tee -a "${LOG_FILE}"

