#!/bin/bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate input
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required" | tee -a logs/user_info.log
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric" | tee -a logs/user_info.log
    exit 1
fi

# Age category
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

message="Hello $name from $country. You are an $category."

echo "$message" | tee -a logs/user_info.log