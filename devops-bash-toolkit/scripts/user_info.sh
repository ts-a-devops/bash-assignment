#!/bin/bash

OUTPUT_FILE="user_info_output.txt"

is_numeric() {
	[["$1" =~ ^[0-9] +$ ]]
}

read -p "Enter your name: " name
if [ -z "$name" ]; then
	echo "Error: Name cannot be empty."
	exit 1
fi

read -p "Enter your age: " age
if [ -z "$age" ]; then
	echo "Error: Age cannot be empty."
	exit 1
fi

if ! is_numeric "$age"; then
	echo "Error: Age must be numeric."
	exit 1
fi

read -p "Enter your country: " country
if [ -z "$country" ]; then
	echo "error: Country cannot be empty."
	exit 1
fi

if ["$age" -lt 18 ]; then
	category="Minor"
elif [ "$age" -le 65 ]: then
	category="Adult"
else
	category="Senior"
fi

message="Hello, $name from $country! Your are $age years old and categorized as an $category."

echo "$message"
echo "$message" > "$OUTPUT_FILE"


