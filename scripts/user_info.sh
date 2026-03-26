#!/bin/bash

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age (must be number)
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Invalid age. Please enter a number."
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

# Output message
message="Hello $name from $country. You are an $category."

echo "$message"

# Save to log
echo "$message" >> logs/user_info.log
