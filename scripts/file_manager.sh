#!/bin/bash


# I am going to use if/elif statement in this code because i am comparing more than two arguments. 
{
if [ "$1" == "create" ]
then
    touch $2
    echo "The $2 has been created"

elif [ "$1" == "delete" ]
then
    rm $2
    echo "$2 has been deleted"
 
elif [ "$1" == "list" ]
then
    ls 
    echo "All the files have been listed"

elif [ "$1" == "rename" ]
then 
    mv $2 $3
    echo "The file has been renamed"
fi
} >> logs/file_manager.log
