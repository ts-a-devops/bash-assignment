
#!/bin/bash

mkdir -p logs

LOG_FILE="logs/user_info.log"

log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

read -p "Enter your name: " NAME
read -p "Enter your age: " AGE
read -p "Enter your country: " COUNTRY

if [[ -z "$NAME" || -z "$AGE" || -z "$COUNTRY" ]]; then
    log_message "Error: All fields are required."
    exit 1
fi

if ! [[ "$AGE" =~ ^[0-9]+$ ]]; then
    log_message "Error: Age must be a numeric value."
    exit 1
fi

if (( AGE < 18 )); then
    CATEGORY="Minor"
elif (( AGE >= 18 && AGE <= 65 )); then
    CATEGORY="Adult"
else
    CATEGORY="Senior"
fi

log_message "Hello, $NAME from $COUNTRY!"
log_message "You are $AGE years old."
log_message "Age category: $CATEGORY"

log_message "User information successfully saved to $LOG_FILE"


