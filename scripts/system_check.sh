#!/bin/bash

echo "Enter your name:"
read name

echo "Enter your age:"
read age

echo "Enter your country:"
read country

if [ -z "$name" ] || [ -z "$age" ] || [ -z "$country" ]; then
    echo "Error: All fields are required."
    exit 1
fi