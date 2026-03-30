#!/bin/bash

#this script prints user informations

LOG_FILE="../logs/user_info.log"

#getting user inputs

read -p "what is your name: " name
read -p "how old are you: " age
read -p "country: " country

#To determine age category

if (( age < 18 )); then
    category="Minor"
  elif (( age <= 65 )); then
    category="Adult"
  else 
    category="Senior"
fi    


#To validate user inputs

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "All field are required" | tee -a "$LOG_FILE"
  exit 1
fi

if [[ "$age" =~ ^[0-9]=$ ]]; then
    echo "Age must be numeric" | tee -a "$LOG_FILE"
    read -p "enter your age again: " age
    exit 1
fi


#this line prints all user information
message="welcome to this cohort $name, $age from $country! you are a $category."

echo "$message" | tee -a "$LOG_FILE"
