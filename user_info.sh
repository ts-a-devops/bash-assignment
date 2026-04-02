#!/bin/bash

# This script is to collect user's data

read -p "Enter your name: " name

read -p "Enter your Age: " age

read -p "Enter your Country: " country

# Validating age to be numeric

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Age must be numeric."
    exit 1
fi

# Greeting message for the user

echo "Hello, $name you are $age years old, and you are from $country, welcome onboard."

# categorising the user based on their ages

if (( age < 18 )); then
    category="Minor"
   elif (( age <= 65 )); then
    category="Adult"
   else
    category="Senior"
fi

# Handle missing input

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
echo "All fields (name, age, country) are required."
    exit 1
fi
