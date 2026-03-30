#!/bin/bash

# Prompt the user for:
# name, age, country 


LOG_FILE="../logs/user_info.log"

read -p "What's your name: " name
read -p "How old are you: " age
read -p "Where are you from: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required" | tee -a "$LOG_FILE"
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
      echo "Error: Age must be numeric" | tee -a "$LOG_FILE"
      exit 1
fi

# Determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
     category="Adult"
else
     category="Senior"
fi

message="Hello $name from $country! You are a $category."

echo "$message" | tee -a "$LOG_FILE"
