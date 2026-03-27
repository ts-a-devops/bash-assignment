#!/bin/bash

# Define log file path
LOG_FILE="logs/user_info.log"

# Ensure logs directory exists (creates it if missing)
mkdir -p logs

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate that no field is empty
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

# Validate that age is numeric using regex
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
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

# Create output message
message="Hello $name from $country. You are an $category."

# Display message to user
echo "$message"

# Append message to log file with timestamp
echo "$(date): $message" >> "$LOG_FILE"
