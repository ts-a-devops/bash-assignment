#!/bin/bash

# Prompt for user information
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

# Greeting message
echo "Hello, $name! You are from $country."

# Age category logic
if [ "$age" -lt 18 ]; then
    echo "Age category: Minor"
elif [ "$age" -le 65 ]; then
    echo "Age category: Adult"
else
    echo "Age category: Senior"
fi
