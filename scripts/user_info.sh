#!/bin/bash
## collecting inputs from user
mkdir -p logs
LOG_FILE="logs/user_info.log"

read -p "enter your name " name
read -p "enter your age "  age
read -p "enter your country " country
 echo ""
if ! [[ "$age" =~ ^[0-9]+$ ]]
        then
            echo "Sorry integers only"
fi



if  [[ "$age" -lt 18 ]]; then
     category="Minor"

elif [[ "$age" -ge 18 ]] &&  [[ "age" -le 65 ]]; then
	category="Adults"

elif [[ "age" -gt 65 ]]; then
       category="Senior"

fi

greeting="hello your name is $name, youre $age years and from $country. youre catgorised as $category"


echo "$greeting" | tee -a $LOG_FILE


