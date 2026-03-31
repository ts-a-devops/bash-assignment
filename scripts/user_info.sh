read -p "What is Your Name? " Name
read -p "Your Age " Age
read -p "Enter Your Country " Country


#Validate if age is number

if ! [[ "$Age" =~ ^[0-9]+$ ]]; then
    echo "Invalid Age"
    exit 1
fi

#Handling age category

if [[ "$Age" -lt 18 ]]; then
    Category="Minor"
elif [[ "$Age" -le 65 ]]; then
    Category="Adult"
else
    Category="Senior"
fi
Message="Hello $Name You are from $Country, and You are a $Category"
echo "${Message}" | tee -a ../logs/user_info.log
