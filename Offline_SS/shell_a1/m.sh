#!/bin/bash
IFS=$'\n'
readarray -t frnds <./friends.txt
readarray -t places <./places.txt
[ -e "a.txt" ] && rm "a.txt"
touch a.txt
min=99999
s=""
 for i in ${places[@]};
 do
 	c=$(grep -i -o $i visited.csv | wc -l)
 	echo "$i $c" >> a.txt
 	if((min>c));
 	then
 		s="$i"
 		min=$c
 	fi

 done
 echo "Suitable place $s">>a.txt