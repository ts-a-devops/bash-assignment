#!/bin/bash

LOG_FILE="logs/user_info.log"

echo "===== USER INFORMATION TOOL ====="

read -p "Enter your name: " NAME
read -p "Enter your age: " AGE
read -p "Enter your country: " COUNTRY 

echo ""

# Validate input
if [ -z "$NAME" ] || [ -z "$AGE" ] || [ -z "$COUNTRY" ]; then
  echo "Error: All fields are required."
  exit 1
fi

# Check numeric age
if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
  echo "Error: Age must be a number."
  exit 1
fi

# Age category
if [ "$AGE" -lt 18 ]; then
  CATEGORY="Minor"
elif [ "$AGE" -le 65 ]; then
  CATEGORY="Adult"
else
  CATEGORY="Senior"
fi

echo "--------------------------------" | tee -a "$LOG_FILE"
echo "Hello $NAME from $COUNTRY!" | tee -a "$LOG_FILE"
echo "You are classified as: $CATEGORY" | tee -a "$LOG_FILE"
echo "--------------------------------" | tee -a "$LOG_FILE"
