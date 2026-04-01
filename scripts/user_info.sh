#!/bin/bash

# Prompt user for information
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

# Greeting message
echo "Hello, $name! Welcome from $country."

# Age category
if [ "$age" -lt 18 ]; then
    category="Minor"
elif [ "$age" -le 65 ]; then
    category="Adult"
else
    category="Senior"
fi

echo "Age Category: $category"

# Save output to log file
output="Name: $name | Age: $age | Country: $country | Category: $category"
echo "$output" > ~/bash-assignment/logs/user_info.log
echo "$output"
echo "Output saved to logs/user_info.log"
