#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number!"
    exit 1
fi

# Greeting message
echo "Hello $name from $country!"

# Age category
if [ "$age" -lt 18 ]; then
    echo "Age category: Minor"
elif [ "$age" -le 65 ]; then
    echo "Age category: Adult"
else
    echo "Age category: Senior"
fi

# Save output to log
echo "Name: $name | Age: $age | Country: $country" >> logs/user_info.log
echo "Log saved to logs/user_info.log"
