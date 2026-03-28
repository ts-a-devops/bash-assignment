#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required!"
    exit 1
fi

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number!"
    exit 1
fi

# Greeting message
echo "Hello $name from $country!"

# Age category
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

echo "Age category: $category"

# Save output to log
echo "$(date): Name=$name | Age=$age | Country=$country | Category=$category" >> logs/user_info.log

echo "Log saved to logs/user_info.log"
