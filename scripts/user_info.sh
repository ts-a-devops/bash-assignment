#!/bin/bash
# This is a script that asks for your information

# Create logs folder
mkdir -p logs

echo "Welcome to User Information"

# Ask questions
read -p "What is your Name? " name
read -p "What is your Age? " age
read -p "Which Country are you from? " country

# Check if user entered something
if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
    echo "Error: Please fill all the information!"
    exit 1
fi

# Check if age is a number
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number only!"
    exit 1
fi

# Decide if Minor, Adult or Senior
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# Show the result
echo "Hello $name from $country!"
echo "You are $age years old → You are a/an $category."

# Save the information to a log file
{
    echo "=== $(date) ==="
    echo "Name     : $name"
    echo "Age      : $age"
    echo "Country  : $country"
    echo "Category : $category"
    echo "----------------------------------------"
} >> logs/user_info.log

echo "Your information has been saved to logs/user_info.log"