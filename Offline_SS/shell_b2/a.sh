#!/bin/bash
#$sed 's/unix/linux/' geekfile.txt //replace unix by linux
#$sed 's/unix/linux/2' geekfile.txt //replace 2nd occurence g hole all occurence
#$sed '3 s/unix/linux/' geekfile.txt //3 no line e korbe 1,3 dile 1-3 range
#STR=$(IFS=,; echo "$*")
#ls -t -aR | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//  /g'
#ls -t -aR | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//  /g'
#`ls -t -aR | grep ":$" | perl -pe 's/:$//;s/[^-][^\/]*\//    /g;s/^    (\S)/└── \1/;s/(^    |    (?= ))/│   /g;s/    (\S)/└── \1/'`
#--ignore={$STR}
#ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//  /g'



# Set space as the delimiter
#IFS=' '

#Read the split words into an array based on space delimiter
#read -a strarr <<< "$text"


#while IFS="," read -r rec1 rec2
#do
 # echo "Displaying Record-$rec1"
 # echo "Price: $rec2"
#done < <(cut -d "," -f1,3 input.csv | tail -n +2)


a=()
for i in $*;
do
	a+=("$i")
done
STR=$(IFS=,; echo "${a[@]}")
fopt=()
for f in "${a[@]}"; do
  if [ "${#fopt[@]}" -eq 0 ]; then
    fopt+=("-name '$f'")
  else
    fopt+=("-o -name '$f'")
  fi
done
find . ! -name $STR| sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/" | sort -n