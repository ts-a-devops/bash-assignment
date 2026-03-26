#!/bin/bash

LOG_FILE="logs/user_info.log"

# Create logs directory
mkdir -p logs

# Name
while true; do
  read -p "Enter your name: " name
  if [[ -n "$name" ]]; then
    break
  else
    echo "Error: Name cannot be empty."
  fi
done

# Age
while true; do
  read -p "Enter your age: " age
  if [[ "$age" =~ ^[0-9]+$ ]]; then
    break
  else
    echo "Error: Age must be numeric."
  fi
done

# Country
while true; do
  read -p "Enter your country: " country
  if [[ -n "$country" ]]; then
    break
  else
    echo "Error: Country cannot be empty."
  fi
done

# Age category
if [ "$age" -lt 18 ]; then
  category="Minor"
elif [ "$age" -le 65 ]; then
  category="Adult"
else
  category="Senior"
fi

# Output
message="Hello $name from $country! You are an $category."
echo "$message"

# Log
echo "$(date): $message" >> "$LOG_FILE"
