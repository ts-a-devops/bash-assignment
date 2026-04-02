#!/usr/bin/env bash

mkdir -p logs
LOG_FILE="logs/user_info.log"

read -rp "Enter your name: " name
read -rp "Enter your age: " age
read -rp "Enter your country: " country

timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

if [[ -z "$name" || -z "$age" || -z "$country" ]]; then
  message="[$timestamp] Error: Missing input. Name, age, and country are required."
  echo "$message"
  echo "$message" >> "$LOG_FILE"
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  message="[$timestamp] Error: Age must be numeric."
  echo "$message"
  echo "$message" >> "$LOG_FILE"
  exit 1
fi

if (( age < 18 )); then
  category="Minor"
elif (( age <= 65 )); then
  category="Adult"
else
  category="Senior"
fi

message="[$timestamp] Hello, $name from $country. You are $age years old and classified as: $category."
echo "$message"
echo "$message" >> "$LOG_FILE"

