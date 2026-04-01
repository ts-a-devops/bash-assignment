#!/bin/bash
# user_info.sh - Collects and displays user information

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/user_info.log"

echo "==============================="
echo "       USER INFO COLLECTOR     "
echo "==============================="

# Prompt for Name
read -rp "Enter your name: " NAME
if [[ -z "$NAME" ]]; then
    echo "Error: Name cannot be empty."
    exit 1
fi

# Prompt for Age
read -rp "Enter your age: " AGE
if [[ -z "$AGE" ]]; then
    echo "Error: Age cannot be empty."
    exit 1
fi

if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a numeric value. You entered: '$AGE'"
    exit 1
fi

# Prompt for Country
read -rp "Enter your country: " COUNTRY
if [[ -z "$COUNTRY" ]]; then
    echo "Error: Country cannot be empty."
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

# Display greeting and info
echo ""
echo "==============================="
echo "Hello, $NAME! Welcome from $COUNTRY."
echo "Age: $AGE → Category: $CATEGORY"
echo "==============================="

# Save to log
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
{
    echo "[$TIMESTAMP]"
    echo "Name: $NAME"
    echo "Age: $AGE"
    echo "Country: $COUNTRY"
    echo "Category: $CATEGORY"
    echo "---"
} >> "$LOG_FILE"

echo "Info saved to $LOG_FILE"
