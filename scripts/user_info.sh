#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Prompt user for input
echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Enter your country:"
read country

# Validate input
if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
    echo "Error: All fields are required."
    exit 1
fi

# Validate age is numeric
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

# Output message
echo "Hello $name from $country!"
echo "You are classified as: $category"

# Save to log file
echo "Name: $name | Age: $age | Country: $country | Category: $category" >> logs/user_info.log