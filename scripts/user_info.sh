#!/bin/bash

LOG_FILE="logs/user_info.log"

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# validation
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number."
    exit 1
fi

# category
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

message="Hello $name from $country. You are $age years old ($category)."

echo "$message"
echo "$(date): $message" >> "$LOG_FILE"
