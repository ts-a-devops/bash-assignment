#!/bin/bash

mkdir -p logs

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
echo "All fields are required"
exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
echo "Age must be a number"
exit 1
fi

if [[ "$age" -lt 18 ]]; then
category="Minor"
elif  
[[ "$age" -le 65 ]]; then
category="Adult"
else
category="Senior"
fi

message="Hello $name, you are from $country and you are a $category."

echo "$message"
echo "$(date): $message" >> logs/user_info.log


