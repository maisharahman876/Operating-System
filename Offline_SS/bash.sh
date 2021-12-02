#!/bin/bash
all_file(){
for path in "$1"/*; do
	if [ -d "$path" ]
	then
		for dfile in "$path"; do
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
curr_dir="$(pwd)"/
mkdir -p output_dir
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
		j=0
		for k in ${!arr[@]}; do
			ex="${arr[$k]}"
			if [[ "$ex" = "$fileext" ]];
			then
				j='expr $j+1'
			fi
		done

		if [[ "$j" = 0 ]];
		then
			mkdir -p output_dir/"$fileext"
			cp "$path" output_dir/"$fileext"
			touch -a output_dir/"$fileext"/desc_"$fileext".txt
			echo "$path" >>output_dir/"$fileext"/desc_"$fileext".txt
		fi
	else
		mkdir -p output_dir/others
		cp "$path" output_dir/others
		touch -a output_dir/others/desc_others.txt
		echo "$path" >>output_dir/others/desc_others.txt
	fi
done