#!/usr/bin/env bash

prompt() {
    local name=${1:-}
    local age
    local country=${2:-}

    while true; do
        read -p "Enter age: " age
        if [[ ! $age =~ ^([1-9][0-9]*|0)$ ]]; then
            echo "Invalid age, try again"
        else
            echo "Valid age: $age"
            break
        fi
    done
if [[ ${age} -lt 18 ]]; then
    echo "You are a minor"
elif [[ ${age} -gt 65 ]]; then
    echo "You are an adult"
else
    echo "You are a senior"
fi



    echo "Your name is ${name} and you are from ${country}, the /$/{result of api_call /}"
    echo "Country: ${country}"
}
[[ -d "logs" ]] || mkdir logs
[[ -d "logs" ]] && cd logs || exit
touch "user_info.log"

prompt "$@" > "user_info.log"