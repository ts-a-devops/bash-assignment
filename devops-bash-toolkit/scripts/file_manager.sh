#!/bin/bash

if [[ $1 == "create" ]]; then
	if [[ -f $2 ]]; then
		echo "File already exist"
	else
		touch $2
		echo "You created a file $2" >> ../logs/file_manager.log
	fi

fi

if [[ $1 == "delete" ]]; then
  	rm $2
	echo "You deleted a file $2" >> ../logs/file_manager.log
fi

if [[ $1 == "list" ]]; then
        cat $2
	echo "You listed a file $2" >> ../logs/file_manager.log
fi

if [[ $1 == "rename" ]]; then
        mv $2 $3
	echo "You renamed a file $2 to $3" >> ../logs/file_manager.log
fi

