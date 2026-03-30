#!/bin/bash

LOG_FILE="../logs/user_info.log"

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

# To validate inputs
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
    echo "Error, All fields are required" | tee -a "$LOG_FILE"
    exit 1
fi

# To validate if age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error, Age must be a numeric value" | tee -a "$LOG_FILE"
    exit 1
fi

# To determine age category
if (( age < 18 )); then
    category="Minor"
elif (( age <= 65 )); then
    category="Adult"
else
    category="Senior"
fi

echo "Hello $name from $country!" | tee -a "$LOG_FILE"
echo "You are $age years old" | tee -a "$LOG_FILE"
echo "You fall in the category of $category" | tee -a "$LOG_FILE"

