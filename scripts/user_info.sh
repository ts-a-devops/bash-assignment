#!/bin/bash

# Prompt user input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Check for empty inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

# Validate age (it must be number)
while ! [[ "$age" =~ ^[0-9]+$ ]]; do
      echo "invalid age. Please enter a number."
      read age
done


# Determine age category
if [ "$age" -lt 18 ]; then
     category="Minor"
elif [ "$age" -le 65 ]; then
     category="Adult"
else
     category="Senior"
fi

# Output message
message="Hello $name from $country. You are $category."
echo "$message"

# save to log
mkdir -p ../logs
echo "$(date): $name, $age, $country, $category" >> ../logs/user_info.log
