#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/user_info.log"

# Prompt for Name
read -rp "Enter your name: " name
if [[ -z "$name" ]]; then
  echo "❌ Error: Name cannot be empty."
  exit 1
fi

# Prompt for Age
read -rp "Enter your age: " age
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "❌ Error: Age must be a numeric value."
  exit 1
fi

# Prompt for Country
read -rp "Enter your country: " country
if [[ -z "$country" ]]; then
  echo "❌ Error: Country cannot be empty."
  exit 1
fi

# Determine age category
if [[ "$age" -lt 18 ]]; then
  category="Minor"
elif [[ "$age" -le 65 ]]; then
  category="Adult"
else
  category="Senior"
fi

# Build output
output="
========================================
  User Information
========================================
  Name    : $name
  Age     : $age ($category)
  Country : $country
  Date    : $(date '+%Y-%m-%d %H:%M:%S')
========================================
"

echo "$output"

# Save to log
echo "$output" >> "$LOG_FILE"
echo "✅ Output saved to $LOG_FILE"

