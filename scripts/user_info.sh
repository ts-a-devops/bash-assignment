#!/bin/bash
LOG_FILE="logs/user_info.log"
mkdir -p logs

while true; do
    read -p "Enter your Name: " NAME
    if [[ -n "$NAME" ]]; then break; fi
    echo "Error: Name is required."
done

while true; do
    read -p "Enter your Age: " AGE
    case "$AGE" in
        "") echo "Error: Age is required." ;;
        *[!0-9]*) echo "Error: '$AGE' is not a number." ;;
        *) break ;;
    esac
done

read -p "Enter your Country: " COUNTRY
COUNTRY=${COUNTRY:-"Unknown Country"}

# --- Categorization ---
if [ "$AGE" -lt 18 ]; then
    CAT="Minor"
elif [ "$AGE" -le 65 ]; then
    CAT="Adult"
else
    CAT="Senior"
fi

# --- Final Output ---
MESSAGE="Greeting $NAME from $COUNTRY! Category: $CAT"
echo "$MESSAGE" | tee -a "$LOG_FILE"
