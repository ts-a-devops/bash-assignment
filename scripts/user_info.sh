#!/bin/bash

mkdir -p logs
LOG_FILE="logs/user_info.log"X

echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Enter your country:"
read country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required!"
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number!"
    exit 1
fi

if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

message="Hello $name from $country! You are an $category."

echo "$message"
echo "$message" >> "$LOG_FILE"
