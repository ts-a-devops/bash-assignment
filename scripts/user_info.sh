#!/bin/bash

LOG_FILE="../logs/user_info.log"

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]];then
    echo "Error: All fields are required."
    exit 1
fi

# Check if age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]];then
    echo"Error: Age must be a number."
    exit 1
fi

# Determine age category
if (( age < 18 ));then
    category="Minor"
elif (( age <= 65 ));then 
    category="Adult"
else
    category="Senior"
fi

# Greeting message
message="Hello $name from $country! You are an $category."


#save to log file
echo "$message" | tee -a "$LOG_FILE"
