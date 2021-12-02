#!/bin/bash
all_file(){
IFS=$''
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
ignored=0
read -p "Enter Directory: " dir
read -p "Enter Source File: " file
curr_dir="$(pwd)"/
mkdir -p output_dir
touch output.csv
echo file_type,no_of_files>> output.csv
while read line;
do 
	arr+=($line)
	#echo $line
done < $file
all_file "$dir"
IFS=$''
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
				j=$((j+1))
			fi
		done

		if [[ "$j" = 0 ]];
		then
			if [[ -v "$fileext" ]]; then
				$fileext=0
			fi
			mkdir -p output_dir/"$fileext"
			cp "$path" output_dir/"$fileext"
			touch -a output_dir/"$fileext"/desc_"$fileext".txt
			echo "$path" >>output_dir/"$fileext"/desc_"$fileext".txt
			
		else
			ignored=$((ignored+1))
		fi
	else
		mkdir -p output_dir/others
		cp "$path" output_dir/others
		touch -a output_dir/others/desc_others.txt
		echo "$path" >>output_dir/others/desc_others.txt
	fi
done
for i in output_dir/*; do
	size=-1
	for j in "$i"/*; do
		size=$((size+1))
	done
	filename=$(basename -- "$i")

	echo $filename,"$size" >> output.csv

done
echo ignored,$ignored >> output.csv