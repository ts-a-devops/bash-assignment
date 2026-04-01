#!bin/bash/

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/user_info.log

#Create logs directory
mkdir -p $LOG_DIR

#Prompt user
read -p "What is your name: " name

read -p "Enter your age: " age

read -p "What country are you from:" country

#Validate input
if [[ -z "$name"|| -z "$age" || -z "$country"]]; then
	echo "Error: All fields are required!"
	exit 1
fi


if ![["$age"=~^[0-9]+$]]; then
	echo "Error: Age must be numeric!"
	exit 1
fi

#Age category
if [[age < 18]]; then
	category="minor"
elif [[age <=65]]; then
	category="adult"
else [[ age 65+]]; then
	category="senior"
fi

#Greeting
message="Hello, $name! welcome from $country! You are an $category."
echo "$message"

#Save to log
echo "$(date): $message">> $LOG_FILE

