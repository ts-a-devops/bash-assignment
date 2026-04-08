#!/bin/bash

#Welcome Greeting and consent
echo Hi welcome to Eniiyi cafe. May i know you?

#Reading customers input
read -p "Y/N: " response

#CONDITIONALS	
#
#if response is yes
#
  if [[ "$response" == "Y" || "$response" == "y" ||"$response" == "Yes" ||"$response" == "yes" ]]; then
    
	  read -p "What is your name :" name
    echo ""

    read -p "How old are you :" age

#Validating Numeric age using regex conditionals
#

   if [[ "$age" =~ ^[0-9]+$ ]]; then
	   #save value in variable category
	   
	   category=$age

	   if [[ "$age" -lt 18 ]]; then
		   category="Minor"

	   elif [[ $age -ge 18 && $age -le 65 ]]; then
		   category="Adult"
	   else
		   category="Senior"
	   fi
	   
   else
	   
	echo "Digits only. Tryagain later"
	   exit 1
   fi

 echo""   
 

 read -p "What country are you from:" Country

 echo""


#Output
Output="Nice to meet you, $name! You are a $age year old  $category from $Country." 

echo "$Output"  

#Pass output to log file with date and time
#
echo "$Output $(date)" >> logs/user_info.log


   #if response is no
   #
 elif [[ "$response" == "N" || "$response" == "n" ||"$response" == "No" ||"$response" == "no" ]]; then
	echo "Bye for now."
else
  echo "Wrong input, try again later"
  exit 1
fi

