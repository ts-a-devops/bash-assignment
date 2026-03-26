#!/bin/bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: Missing input"
    echo "Invalid input" >> logs/user_info.log
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Age must be numeric"
    echo "Invalid age entered" >> logs/user_info.log
    exit 1
fi

if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

message="Hello $name from $country. You are classified as: $category."

echo "$message"
echo "$(date) - $message" >> logs/user_info.log