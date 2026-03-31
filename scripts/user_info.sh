#!/bin/bash

LOG_FILE="../logs/user_info.log"

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate name
if [[ -z $name ]]; then
    echo "Invalid name input" | tee -a "$LOG_FILE"
    exit 1
fi

# Validate country
if [[ -z $country ]]; then
    echo "Invalid country input" | tee -a "$LOG_FILE"
    exit 1
fi

# Validate age
if ! [[ $age =~ ^[0-9]+$ ]]; then
    echo "Invalid age. Please enter a number" | tee -a "$LOG_FILE"
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

# Output message
message="Hello, $name from $country. You are an $category."

echo "$message" | tee -a "$LOG_FILE"