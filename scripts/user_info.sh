#!/bin/bash
set -euo pipefail

LOG_FILE="logs/user_info.log"

# Prompt user input
read -p "Enter your name: " NAME
read -p "Enter your age: " AGE
read -p "Enter your country: " COUNTRY

# Validate inputs
if [[ -z "$NAME" || -z "$AGE" || -z "$COUNTRY" ]]; then
  echo "Error: Missing input — please provide NAME, AGE, and COUNTRY before continuing."
  exit 1
fi

if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
  echo "Error: Error: Invalid AGE — please enter a numeric value."
  exit 1
fi

# Determine age category
if (( AGE < 18 )); then
  CATEGORY="Minor"
elif (( AGE <= 65 )); then
  CATEGORY="Adult"
else
  CATEGORY="Senior"
fi

# Determine correct article (a / an)
if [[ "$CATEGORY" == "Adult" ]]; then
  ARTICLE="an"
else
  ARTICLE="a"
fi

# Output message
MESSAGE="Hello $NAME from $COUNTRY. You are $ARTICLE $CATEGORY."

echo "$MESSAGE"

# Log output
echo "$(date): $MESSAGE" >> "$LOG_FILE"
