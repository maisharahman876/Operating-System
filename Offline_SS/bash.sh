#!/bin/bash
all_file(){
for path in "$1"/*; do
	if [ -d "$path" ]
	then
		for dfile in "$path"/; do
			all_file "$dfile"
		done
	else
		files+=($path)
	fi
	done
}
arr=()
files=()
i=0
read -p "Enter Directory: " dir
read -p "Enter Source File: " file
while read line;
do 
	arr+=($line)
	#echo $line
done < $file
all_file "$dir"
for i in ${!files[@]}; do
	path="${files[$i]}"
	filename=$(basename -- "$path")
	fileext=${filename##*.}
	if [[ "$filename" != "$fileext" ]]
	then
		
		echo "$fileext" 
		echo "$filename"

	fi
done