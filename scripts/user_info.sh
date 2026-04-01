#!/bin/bash


# A fuction to check for empty input
check_empty_var() {
	if [[ -z "$1" ]]; then 
		echo "You did not enter a $2"
	   exit 1
	fi	
}

# Prompt name
read -p "Enter your name: " name
 check_empty_var "$name" "name"

# Prompt age
read -p "Enter your age: " age
check_empty_var "$age" "age"

# Check if age is a number
  if [[ ! $age =~ ^[0-9]+$ ]]; then
 	echo "Age is not a number."
	exit 1
  fi
 
# Group the age based on a condition 
  if [[ $age -lt 18 ]]; then
	  age_group="Minor"

  elif [[ $age -ge 18 && $age -le 65 ]]; then
	  age_group="Adult"

  elif [[ $age -gt 65 && $age -lt 120 ]]; then
	  age_group="Senior"

  else 
      echo "INVALID VALUE"
      exit 1
  fi


# Prompt for country
read -p "Enter your country: " country
check_empty_var "$country" "country"


message="Greeting $name from $country you are  $age years old and you are grouped as $age_group"

echo "$message" >> logs/user_info.log

