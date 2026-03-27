#!/bin/bash
LOG_FILE="logs/user_info.log"
mkdir -p logs
# prompt users for inputs
read -p "Enter your name: " name
read -p "Enter your age: " age
read -p "Enter your city: " city
read -p "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$city" || -z "$country" ]]; then
echo "Error: All fields must be completed" | tee -a "$LOG_FILE"
exit 1
fi

# validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
echo "Error: Age must be numeric" | tee -a "$LOG_FILE"
exit 1
fi
# output greeting
echo "Hello $name, from $country!" | tee -a "$LOG_FILE"

# age categories
if [[ "$age" -lt 18 ]]; then
echo "Category: Minor" | tee -a "$LOG_FILE"
elif [[ "$age" -ge 18 && "$age" -le 65 ]]; then 
echo "Category: Adult" | tee -a "$LOG_FILE"
else 
echo "Category: Senior" | tee -a "$LOG_FILE"
fi
