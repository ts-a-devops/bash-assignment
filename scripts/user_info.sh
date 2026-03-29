#!/bin/bash

# Log file
LOG_FILE="../logs/user_info.log"

# Ensure log directory exists
mkdir -p ../logs

echo "===== User Info Script ====="

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
	    echo "Error: All fields are required."
	        echo "$(date) - ERROR: Missing input" >> "$LOG_FILE"
		    exit 1
fi

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
	    echo "Error: Age must be a number."
	        echo "$(date) - ERROR: Invalid age input ($age)" >> "$LOG_FILE"
		    exit 1
fi

# Determine age category
if (( age < 18 )); then
	    category="Minor"
    elif (( age >= 18 && age <= 65 )); then
	        category="Adult"
	else
		    category="Senior"
fi

# Output greeting
echo "Hello $name from $country!"
echo "You are an $category."

# Log output
echo "$(date) - Name: $name | Age: $age | Country: $country | Category: $category" >> "$LOG_FILE"

echo "Information saved to log."
