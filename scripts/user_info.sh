#!/bin/bash

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  echo "All fields are required"
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Age must be numeric"
  exit 1
fi

if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi

message="Hello $name from $country. You are an $category."

echo "$message"
echo "$(date): $message" >> logs/user_info.log
