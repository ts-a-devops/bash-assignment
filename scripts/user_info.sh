#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

echo "==== User Information Script ===="

# Prompt user
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

# Validate age (must be number)
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    exit 1
fi

# Determine age category
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# Greeting message
message="Hello $name from $country! You are an $category."

echo "$message"

# Save to log file
echo "$(date): $message" >> logs/user_info.log
