#!/bin/bash

# Create logs folder if it doesn't exist
mkdir -p logs

# Ask the user for information
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Check if age is a valid number
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "❌ Error: Age must be a number!"
  exit 1
fi

# Figure out age category
if [ "$age" -lt 18 ]; then
  category="Minor"
elif [ "$age" -le 65 ]; then
  category="Adult"
else
  category="Senior"i

# Print and save the result
message="Hello $name from $country! You are classified as: $category"
echo "$message"
echo "$message" >> logs/user_info.log
