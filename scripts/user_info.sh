er_info.sh!/bin/bash
mkdir -p logs
# THIS SCRIPT IS TO COLLECT USERS INFO 
echo "=== USER INFO ==="
#THIS ACCEPT USERS NAMES, AGE AND COUNTRY
read -p "enter your Name correcly?: " Name 
Name=${Name^^}
read -p "enter your Age?: " Age
read -p "what country are you from?: " country
#Say Hello to our Client
echo "hello $Name  from  $country WELCOME TO BASSPRIZZY AGRO FARM"

if [[ -z "$Age" ]]; then # this strings tells you if the input is empty
    echo "Error: no input provided"
    exit 1
fi
# Checking if its numeric 
if ! [[ "$Age" =~ ^[0-9]+$ ]]; then
    echo "xxxxxxxxxxxxx age must be a number "
    exit 1
fi
#categorise 
if ((Age < 18 )) ; then
    echo "MINOR"
    categories="minor"
elif ((Age <= 65 )) ; then
    echo "Adult"
    categories="Adult"
else 
    categories="senior"
fi
##output 
Result="Age:$Age >>>>> Categories:$categories"
echo " $Result"
echo "$Result" >> logs/user_info.log

