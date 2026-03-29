#!/bin/bash

# Ensure the logs directory exists
mkdir -p logs

# Function to handle graceful exit on invalid input
exit_error() {
    echo "Error: $1"
    exit 1
}

# --- 1. Prompt for Input ---
read -p "Enter your Name: " name
[[ -z "$name" ]] && exit_error "Name cannot be empty."

read -p "Enter your Age: " age
# Validate: Age must be a positive integer
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    exit_error "Age must be a numeric value."
fi

read -p "Enter your Country: " country
[[ -z "$country" ]] && exit_error "Country cannot be empty."

# --- 2. Age Categorization ---
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# --- 3. Format Output ---
greeting="Hello $name from $country!"
info_msg="Age: $age | Category: $category"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# --- 4. Display and Save Output ---
echo "------------------------------"
echo "$greeting"
echo "$info_msg"
echo "------------------------------"

# Append to log file
{
    echo "[$timestamp]"
    echo "User: $name"
    echo "Location: $country"
    echo "Status: $info_msg"
    echo "------------------------------"
} >> logs/user_info.log

echo "Information saved to logs/user_info.log"


