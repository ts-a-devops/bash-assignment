#!/bin/bash

# Prompt user for input
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# Validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error: All fields are required. Please try again."
    exit 1
fi

# Check if age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value."
    exit 1
fi

# Determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age >= 18 && age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

# Output greeting message
echo "Hello $name from $country!"
echo "You are classified as: $category"
echo "A greeting message"

# make file executable 
chmod +x user_info.sh

#Run the file 
./user_info.sh

