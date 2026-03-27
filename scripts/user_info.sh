#!/bin/bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required"
    exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number"
    exit 1
fi

if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

output="Hello $name from $country. You are an $category."

echo "$output"
echo "$output" >> logs/user_info.log

