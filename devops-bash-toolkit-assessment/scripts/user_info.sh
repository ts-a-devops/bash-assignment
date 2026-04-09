#!/bin/bash
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/user_info.log"

# Prompt the user for: Name, Age, Country
read -p "What is your Name: " Name
read -p "What is your Age: " Age
read -p "What is your Country: " Country
# Validate inputs
if [[ -z "$Name" || -z "$Age" || -z "$Country" ]]; then
    echo "All fields are required." | tee -a "$LOG_FILE"
    exit 1
fi
# Validate: Age must be numeric
if ! [[ $Age =~ ^[0-9]+$ ]] ; then
    echo "Age must be numeric" | tee -a "$LOG_FILE"
    exit 1
fi
# Output: A greeting message
echo "Welcome on board, $Name from $Country, aged $Age. Nice to meet you!" | tee -a "$LOG_FILE"
# Age category
if (( Age < 18 )); then
    echo "Minor (<18)" | tee -a "$LOG_FILE"
elif (( Age >= 18 && Age <= 65 )); then
    echo "Adult (18–65)" | tee -a "$LOG_FILE"
else
    echo "Senior (65+)" | tee -a "$LOG_FILE"
fi



