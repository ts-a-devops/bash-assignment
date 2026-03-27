#!/bin/bash


# 1. Setup Logging Environment
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log"

# Create log directory if it doesn't exist (DevOps Best Practice)
if [ ! -d "$LOG_DIR" ]; then
    mkdir "$LOG_DIR"
fi

# 2. Capture User Input
echo "--- User Information Portal ---"

read -p "Enter your Name: " NAME
# Check if Name is empty
if [ -z "$NAME" ]; then
    echo "Error: Name cannot be empty."
    exit 1
fi

read -p "Enter your Age: " AGE
# Validate: Age must be numeric
if [[ ! "$AGE" =~ ^[0-9]+$ ]]; then
    echo "Error: Age must be a valid number."
    exit 1
fi

read -p "Enter your Country: " COUNTRY
if [ -z "$COUNTRY" ]; then
    echo "Error: Country cannot be empty."
    exit 1
fi

# 3. Determine Age Category
if [ "$AGE" -lt 18 ]; then
    CATEGORY="Minor"
elif [ "$AGE" -le 65 ]; then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

# 4. Prepare Output Message
GREETING="Hello $NAME from $COUNTRY! You are categorized as: $CATEGORY."

# 5. Output to Terminal and Log File
echo "------------------------------"
echo "$GREETING"

# Append to log with a timestamp (Crucial for audit trails in banking)
echo "$(date '+%Y-%m-%d %H:%M:%S') - $GREETING" >> "$LOG_FILE"

echo "Success: Information saved to $LOG_FILE"


