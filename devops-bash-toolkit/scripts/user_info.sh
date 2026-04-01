#!/bin/bash

#Get the user's name
read -p "Enter your name: " user_name

#This function will validate the users age and check if it's numerical
while true; do
    read -p "Enter your age: " user_age
    
    # Validation: not empty and numerical
    if [[ -z "$user_age" ]]; then
        echo "Error: Age cannot be empty!"
        continue
    fi
    
    if [[ ! "$user_age" =~ ^[0-9]+$ ]]; then
        echo "Error: Age must be a number!"
        continue
    fi
    
    # Determine category
    if [[ "$user_age" -lt 18 ]]; then
        user_category="Minor (< 18)"
    elif [[ "$user_age" -ge 18 && "$age" -le 65 ]]; then
        user_category="Adult (18-65)"
    else
        user_category="Elder (> 65)"
    fi
    
    echo "Age: $age years - Category: $user_category"
    break
done

#Prompt to get the user's country
read -p "Enter your Country: " user_country

#Print the user's information with a welcome message
echo "Hello, $user_name! you are $user_age and your are from $user_country, based on your age($user_age) you are regarded as 
a $user_category."

#Define the log path
LOG_FILE="logs/user_info.log"

#Create a timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

#Print to the console AND save to the log file at the same time
echo "[$TIMESTAMP] Name: $user_name | Age: $user_age | Category: $user_category | Country: $user_country" | tee -a "$LOG_FILE"