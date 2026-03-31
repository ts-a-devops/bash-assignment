#!/bin/bash

# Age limit
age_limit=120

# Age category
category=""

LOGFILE="logs/user_info.log"

# Welcome message
echo "This script determines the user's age category based on their input"

# Get user's name
read -p  "What is your name?: " name

# Error Handling
# Checks for empty input & integers
# If any is true, loop until user inputs valid info
while [[ -z "$name" || "$name" =~ ^[0-9]+$ ]]
do
   echo "Invalid input. Please try again"
   read -p  "What is your name?: " name
done

# Get user's age
read -p "How old are you?: " age


# Error Handling    
# Checks for empty input, age is zero, age is not an integer, age is equal to zero and age is greater than 120 
# If any is true, loop until user inputs valid info
while [[ -z "$age" || ! "$age" =~ ^[0-9]+$ || "$age" -eq 0 || "$age" -gt "$age_limit" ]]
do
  echo "Invalid age. Please enter a number between 1 and 120"
  read -p "How old are you?: " age
done


# Get user's country
read -p "What country are you from? " country

# Error Handling    
# Checks for empty input & integers 
# If any is true, loop until user inputs valid info
while [[ -z "$country" || "$country" =~ ^[0-9]+$ ]]
do
   echo "Invalid input. Please try again"
   read -p "What country are you from? " country
done

if [[ "$age" -lt 18 ]]; then
#   echo "Minor"
   category="a Minor"
elif [[ "$age" -ge 18 && "$age" -le 65  ]]; then
#   echo "Adult"
   category="an Adult"
elif [[ "$age" -gt 65 ]]; then
#   echo "Senior"
   category="a Senior"
fi

echo "Hello, $name. You are $age years old. You are from $country and you are considered $category" >> logs/user_info.log
