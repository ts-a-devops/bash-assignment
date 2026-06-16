#!/bin/bash

#save output to: logs/user_info.log
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/user_info.log"
mkdir -p "$LOG_DIR"

echo "USER INFO"

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Check for missing input
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields (name, age, country) are required."
    exit 1
fi

# Validate age (must be numeric)
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

# Determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Output results
echo "Hello, $name from $country!"
echo "You are $age years old."
echo "Category: $category"






