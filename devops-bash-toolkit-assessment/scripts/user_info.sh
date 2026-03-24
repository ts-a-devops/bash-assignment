#!/usr/bin/env bash

LOG_FILE="logs/user_info.log"

# Create logs directory if it doesn't exist
mkdir -p logs

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

# Check if age is numeric
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

# Create greeting message
message="Good day $name from $country! You are $age years old ($category)."

# Output message
echo "$message"

# Save to log file
echo "$(date): $message" >> "$LOG_FILE"