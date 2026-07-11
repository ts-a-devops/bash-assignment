#!/bin/bash
exec > >(tee -a logs/user_info.log) 2>&1

# -z means string is empty
read -p "Enter your name:" name
   if [[ -z "$name" ]]; then
    echo "Error, name cannot be empty"
exit
   fi

read -p "Enter your age:" age
   if [[ -z "$age" ]]; then
   echo "Error, age cannot be empty"
exit
   fi

# validaate the age
 if ! [[ "$age" =~ ^[0-9]+$ ]]; then
 echo "Error, age must be a valid number"
exit
 fi

 #promt for country
read -p "Enter your country:" country
   if [[ -z "$country" ]]; then
       echo "Error, country cannot be empty"
exit
   fi

# determine category
if (( "$age" > 18 )); then
      category="Minor"
elif (( "$age" >= 18 && "$age" <= 65 )); then
	      category="Adult"
else 
	      category="Senior"
fi

echo "Hello, $name!"
echo "You're from $country"
echo "Age: $age"
echo "Category: $category"


