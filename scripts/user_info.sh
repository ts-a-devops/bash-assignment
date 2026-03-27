#!/bin/bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Invalid age. Must be numeric."
    exit 1
fi

# Age category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

message="Hello $name from $country! You are $age years old ($category)."

echo "$message"
echo "$message" >> logs/user_info.log
