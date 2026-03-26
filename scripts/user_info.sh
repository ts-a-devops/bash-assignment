#!/bin/bash

LOG_FILE="logs/user_info.log"

# Ensures logs directory exists
mkdir -p logs

# Prompts for user info
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
	echo "Error: all fields are required"
	exit 1
fi

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
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
message="Hello $name from $country! You are $age years old. You fall in the $category category."

# Output to terminal
echo "$message"

# Save to log file
echo "$(date): $message" >> "$LOG_FILE"




