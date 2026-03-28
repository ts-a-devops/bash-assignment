#!/bin/bash

log_file="logs/user_info.log"
mkdir -p logs

# Prompt for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a number"
    exit 1
fi

# Determine age category
if [ $age -lt 18 ]; then
    category="Minor"
elif [ $age -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

# Output
echo "Welcome to devops world of techstar"
echo "Age category: $category"

# Save to log
echo "$(date) - Name: $name, Age: $age ($category), Country: $country" >> "$log_file"