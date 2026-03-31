#!/bin/bash

LOG_FILE="../logs/user_info.log"
mkdir -p ../logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate empty input
if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
    echo "All fields are required."
    echo "Invalid input" >> $LOG_FILE
    exit 1
fi

# Validate numeric age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Age must be numeric."
    echo "Invalid age for $name" >> $LOG_FILE
    exit 1
fi

# Categorize age
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

message="Hello $name from $country! You are a $category."

echo "$message"
echo "$message" >> $LOG_FILE
