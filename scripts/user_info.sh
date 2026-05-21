#!/bin/bash

# Create logs directory
mkdir -p logs

echo "=== User Informstion Tool ===="

read -p "Enter your Name: " name
read -p "Enter your Age: " age
read -p "Enter your Country: " country

# Validation
if [[ -z "$name" || -z "$age" || -z "$country" ]]
then
    echo "Error: All fields are required!" | tee -a logs/user_info.log
    exit 1
fi

if [[ ! "$age" =~ ^[0-9]+$ ]]
then
    echo "Error: Age must be a number!" | tee -a logs/user_info.log
    exit 1
fi

# Age category
if (( age < 18 ))
then
    category="Minor (<18)"
elif (( age < 65 ))
then
    category="Adult (18-65)"
else
    category="Senior (65+)"
fi

greeting="Hello $name from $country! You are $age years old ($category)"

echo "$greeting"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $greeting"  >> logs/user_info.log

echo "Info saved to logs/user_info.log"