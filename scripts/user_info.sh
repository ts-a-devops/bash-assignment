#!/bin/bash
mkdir -p logs
OUTPUT_FILE="logs/user_info.log"

# Function to prompt user and validate age
  # Prompt for Name
  read -p "Enter your Name: " NAME
  while [[ -z "$NAME" ]]; do
    echo "Name cannot be empty. Please enter your Name."
    read -p "Enter your Name: " NAME
  done

  # Prompt for Age
  read -p "Enter your Age: " AGE
  while ! [[ "$AGE" =~ ^[0-9]+$ ]]; do
    echo "Age must be a numeric value. Please enter a valid Age."
    read -p "Enter your Age: " AGE
  done

    # Prompt for Country
  read -p "Enter your Country: " COUNTRY
  while [[ -z "$COUNTRY" ]]; do
    echo "Country cannot be empty. Please enter your Country."
    read -p "Enter your Country: " COUNTRY
  done


# Function to determine age category

  if (( AGE < 18 )); then
    CATEGORY="Minor"
  elif (( AGE < 65 )); then
    CATEGORY="Adult"
  else
    CATEGORY="Senior"
  fi
# Prepare output message
MESSAGE="Hello $NAME from $COUNTRY!
Age: $AGE
Category: $CATEGORY"

echo -e "$MESSAGE"

echo -e "$MESSAGE" > "$OUTPUT_FILE" || echo "Failed to write to log file"
