#!/bin/bash

#save output to: logs/user_info.log
LOG_DIR="../logs"
LOG_FILE="$LOG_DIR/user_info.log"
mkdir -p "$LOG_DIR"

echo "USER INFO"

read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your country: " country

#validate age
if [[ "$age" -lt 18 ]]; then
    category="a minor"
elif [[ "$age" -le 65 ]]; then
    category="an adult"
else
    category="a senior"
fi

#greetings message
echo "Hello ${name}, you are $age years of age"
echo "You are $category from $country"

#save to log
{
    echo "USER INFO"
    echo "Name: $name"
    echo "Age: $age"
    echo "Country: $country"
    echo "Category: $category"
    echo "-----------------------------"
} >> "$LOG_FILE"

echo "Info Saved"