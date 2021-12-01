#!/bin/bash
all_file(){
for path in "$1"/*; do
	if [ -d "$path" ]
	then
		for dfile in "$path"/*; do
			all_file "$dfile"
		done
	else
		echo "$path"
	fi
	done
}
all_file "$1"