#!/bin/bash

LOG_FILE="logs/user_info.log"
mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required" | tee -a "$LOG_FILE"
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be numeric" | tee -a "$LOG_FILE"
    exit 1
fi

if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

message="Hello, $name from $country. You are $age years old and belong to the '$category' category."
echo "$message" | tee -a "$LOG_FILE"
