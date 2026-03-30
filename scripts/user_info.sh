#!/bin/bash

LOG_FILE="logs/user_info.log"
mkdir -p logs

read -p "Enter your name:" name

read -p "Enter your age:" age

read -p "Enter your country:" country

# Validation
if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  echo "Error: All fields are required."
  echo "$(date) - Missing input" >> $LOG_FILE
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number."
  echo "$(date) - Invalid age input: $age" >> $LOG_FILE
  exit 1
fi

# Age category
if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi

message="Hello $name from $country! You are an $category."

echo "$message"

echo "$(date) - $message" >> $LOG_FILE
