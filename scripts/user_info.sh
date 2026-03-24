#!/bin/bash

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
elif (( age >= 18 && age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Create greeting message
message="Hello $name from $country! You are $age years old and classified as $category."

# Display output
echo "$message"

# Save to log file
echo "$(date): $message" >> logs/user_info.log
