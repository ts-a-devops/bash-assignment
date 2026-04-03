#!/bin/bash

LOG_FILE="logs/user_info.log"

# Ensure logs directory exists
mkdir -p logs

echo "=== User Information Script ==="

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

# Check if age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    echo "$(date) - ERROR: Invalid age input ($age)" >> "$LOG_FILE"
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
message="Hello $name from $country! You are an $category."

echo "$message"

# Save to log file
echo "$(date) - Name: $name | Age: $age | Country: $country | Category: $category" >> "$LOG_FILE"
