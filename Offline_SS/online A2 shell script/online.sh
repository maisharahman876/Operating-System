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
[ -e "./output" ] && rm "./output" -r
mkdir output
files=()
dir=classified_01
all_file "$dir"
IFS=$'\n'
readarray -t key <./keywords.txt
for i in ${key[@]}; do
	if [[ -e output/"$i" ]]; then
		var=0
	else
		mkdir output/"$i"
	fi
 flag=0
 for j in ${files[@]}; do
 	count=0
 	count=$(grep -o -i "$i" "$j" | wc -l)
 	if((count!=0));
 	then
 		cp $j output/"$i"
 	fi

 done

done