#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

LOG_FILE="logs/user_info.log"

# Ask user for info
echo "What is your name?:"
read name

echo "How old are you?:"
read age

echo "Where are you from?:"
read country

# Check if any input is empty
if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
    echo "Error: Please fill all fields."
    exit 1
fi

# Check if age is a number
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

# Print greeting
echo "Hello $name from $country!"
echo "You are an $category."

# Save to log file
echo "Name: $name, Age: $age, Country: $country, Category: $category" >> logs/user_info.log

echo "Saved to logs/user_info.log"