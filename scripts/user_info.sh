#!/usr/bin/env bash

mkdir -p logs
LOG_FILE="logs/user_info.log"

read -rp "Enter your name: " name
read -rp "Enter your age: " age
read -rp "Enter your country: " country

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  message="Error: name, age, and country are all required."
  echo "$message"
  echo "$(date '+%F %T') - $message" >> "$LOG_FILE"
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  message="Error: age must be numeric."
  echo "$message"
  echo "$(date '+%F %T') - $message" >> "$LOG_FILE"
  exit 1
fi

if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi

message="Hello, $name from $country. You are $age years old and belong to the $category category."
echo "$message"
echo "$(date '+%F %T') - $message" >> "$LOG_FILE"
