#!/bin/bash
IFS=$'\n'
readarray -t course <./course.txt
s=()

[ -e "m.csv" ] && rm "m.csv"
touch m.csv
n=${#course[@]}
sum=()
while read line; do
	id=`echo $line | cut -c 1-7 `
	s+=("$id")
done < "${course[0]}".txt
echo "student" >>m.csv

s=($(sort <<<"${s[*]}"))
for i in ${s[@]};
do
	
	str=""
	str+=$i","
	mark=0
	for j in ${course[@]};
	do
		
		m=$(grep -n "$i" $j".txt" | cut -d' ' -f2)
		str+=$m","
		mark=$((mark+m))

	done
	str+=$mark","
	echo $str >>m.csv

done