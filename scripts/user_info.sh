#!/usr/bin/env bash

set -euo pipefail

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"
mkdir -p "$LOG_DIR"

read -r -p "Enter your name: " name
read -r -p "Enter your age: " age
read -r -p "Enter your country: " country

if [[ -z "${name// }" ]]; then
  echo "Error: name is required."
  exit 1
fi

if [[ -z "${age// }" ]]; then
  echo "Error: age is required."
  exit 1
fi

if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: age must be numeric."
  exit 1
fi

if [[ -z "${country// }" ]]; then
  echo "Error: country is required."
  exit 1
fi

if (( age < 18 )); then
  category="Minor"
elif (( age < 65 )); then
  category="Adult"
else
  category="Senior"
fi

message="Hello, $name from $country. You are $age years old ($category)."
echo "$message"

printf "%s | name=%s | age=%s | country=%s | category=%s\n" \
  "$(date '+%Y-%m-%d %H:%M:%S')" "$name" "$age" "$country" "$category" >> "$LOG_FILE"
