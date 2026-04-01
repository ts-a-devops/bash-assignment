#!/usr/bin/bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
country_file="$script_dir/countries.txt"

	#Prompt the user for name and making it accept only letters

while true; do
read -p "Name: " name
	if [[ "$name" =~ ^[a-zA-Z[:space:]-]+$ ]]; then
break
    else
	echo "Your name should not contain numbers or symbols"
	fi
done

	#Prompt the user for age and making it accept only number

while true; do
read -p "Age: " age
	if [[ $age =~ ^[0-9]+$ ]]; then
break
    else
	echo "Age must be numeric"
	fi
done

	#Categorizing the age

if (( age < 18 )); then
    category="a minor"
elif (( age < 65 )); then
    category="an adult"
else
    category="a senior"
fi

	#Find a file and then Prompt the user for country
if [[ ! -f "$country_file" ]]; then
	echo "countries.txt not found"
	exit 1
fi

while true; do
read -p "Country: " country
	if ! grep -Fxqi "$country_file" countries.txt;   then
echo "Sharp!"
	break
    else
echo "Nice try! that's not a real country"
	fi
done

	#Output- Greeting message

mkdir -p logs
{
	echo
	echo "$(date '+%B %d %T')"
	echo -e "\n\t Hello $name!"
	echo -e "\n I see you're $age years old, that makes you $category"
	echo -e "\n I hope $country is treating you nice"
	echo -e "\n\t Welcome! It's lovely to have you here"
} | tee -a logs/user_info.log
