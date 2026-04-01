#!/bin/bash

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Invalid age!" | tee -a logs/user_info.log
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

output="Hello $name from $country. You are an $category."

echo "$output" | tee -a logs/user_info.log
