#!/bin/bash


LOG_FILE="logs/user_info.log"   

# 1. Name
read -p "Enter your name:  " name

# Check if name is empty
if [[ -z "$name" ]]; then
  echo "Error: Name cannot be empty."
  exit 1
fi

# 2. Age
read -p "Enter your age: " age

# Validate age is numeric
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a numeric value."
  exit 1
fi

# 3. Country
read -p "Enter your country: " country

# Check if country is empty
if [[ -z "$country" ]]; then
  echo "Error: Country cannot be empty."
  exit 1
fi

# ── Greeting Message ──
{
echo ""
echo "Hello, $name! Welcome from $country."

# ── Age Category ──
if [[ "$age" -lt 18 ]]; then
  echo "Age Category: Minor (under 18)"
elif [[ "$age" -le 65 ]]; then
  echo "Age Category: Adult (18 - 65)"
else
  echo "Age Category: Senior (65+)"
fi
} | tee -a "$LOG_FILE"
