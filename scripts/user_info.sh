#!/bin/bash

# shellcheck disable=SC1091
source "$(dirname "$0")/colors.sh"

# ========== Help ==================================================
show_help() {
    sed -n '/^##HELP_START/,/^##HELP_END/p' "$0" \
        | grep -v '^##HELP' \
        | sed 's/^# \{0,1\}//'
}

make_help() {
    echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║           user_info.sh  —  Help           ║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
    show_help
}

##HELP_START
# DESCRIPTION
#   Collect user information and print a greeting.
# USAGE
#   ./user_info.sh
# EXAMPLES
#   ./user_info.sh
##HELP_END

[[ $# -eq 0 ]] && { make_help; exit 0; }
[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && { make_help; exit 0; }

# Ensure output directory exists before making file writes
mkdir -p logs

# Initialize variables
user_name=""
user_age=""
user_country=""

# Helper function to repeatedly prompt until valid input is given
prompt_value() {
    local prompt_msg="$1"
    local regex="$2"
    local error_msg="$3"
    local var_name="$4"
    local input_val

    while true; do
        read -r -p "$prompt_msg " input_val

        # Check if the user wants to quit (case-insensitive)
        if [[ "${input_val,,}" == "quit" ]]; then
            echo "Program ended by user. Goodbye!"
            exit 0
        fi

        # Verify input using Bash regex matching operator '=~'
        if [[ "$input_val" =~ $regex ]]; then
            # Assign explicitly to the variable name passed in dynamically
            printf -v "$var_name" "%s" "$input_val"
            break
        else
            # Provide specific feedback and let the loop repeat
            echo "Error: $error_msg" >&2
        fi
    done
}

echo "=== User Information Form ==="
echo "(Type 'quit' at any point to exit)"

# 1. Prompt for Name (Require at least one letter, allow spaces)
prompt_value "Enter your Name:" "^[A-Za-z ]+$" "Name must contain only letters and spaces." "user_name"

# 2. Prompt for Age (Require numbers only, at least one digit)
prompt_value "Enter your Age:" "^[0-9]+$" "Age must be numeric." "user_age"

# 3. Prompt for Country (Require at least one letter, allow spaces)
prompt_value "Enter your Country:" "^[A-Za-z ]+$" "Country must contain only letters and spaces." "user_country"

# Evaluate age category constraints
age_cat=""
if (( user_age < 18 )); then
    age_cat="a Minor (<18)"
elif (( user_age >= 18 && user_age <= 65 )); then
    age_cat="an Adult (18–65)"
else
    age_cat="a Senior (65+)"
fi

# Present the greeting message
greeting="Greetings from $user_country to $user_name! Your age is $user_age and you are $age_cat."
echo ""
echo "$greeting"

# Save to log file
log_file="logs/user_info.log"
echo "[$user_name | $(date '+%Y-%m-%d %H:%M:%S')] $greeting" >> "$log_file"
echo "Success: Output saved to $log_file"
