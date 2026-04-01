#!/bin/bash

# Create logs directory if not exists
mkdir -p logs

LOG_FILE="logs/user_info.log"

# Prompt user
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number"
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

# Output
message="Hello $name from $country! You are an $category."

echo "$message"

# Save to log
echo "$(date): $message" >> "$LOG_FILE"
