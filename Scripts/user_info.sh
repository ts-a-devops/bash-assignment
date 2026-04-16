#!/usr/bin/env bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# -----------------------------
# User Input (Controlled Intake)
# -----------------------------

# Name validation
while true; do
  read -p "Enter your name: " NAME
  if [[ -n "$NAME" ]]; then
    break
  else
    echo "Name is required. Please try again."
  fi
done

# Age validation (numeric only)
while true; do
  read -p "Enter your age: " AGE
  if [[ "$AGE" =~ ^[0-9]+$ ]]; then
    break
  else
    echo "Invalid age. Please enter a numeric value."
  fi
done

# Country validation
while true; do
  read -p "Enter your country: " COUNTRY
  if [[ -n "$COUNTRY" ]]; then
    break
  else
    echo "Country is required. Please try again."
  fi
done

# -----------------------------
# Business Logic (Classification)
# -----------------------------

if (( AGE < 18 )); then
  CATEGORY="Minor"
elif (( AGE <= 65 )); then
  CATEGORY="Adult"
else
  CATEGORY="Senior"
fi

# -----------------------------
# Output (Console + Log)
# -----------------------------

OUTPUT=$(cat <<EOF
---------------------------------
Hello $NAME from $COUNTRY
Age Category: $CATEGORY
---------------------------------
EOF
)

# Display to terminal
echo "$OUTPUT"

# Append to log file
echo "$OUTPUT" >> "$LOG_FILE"
