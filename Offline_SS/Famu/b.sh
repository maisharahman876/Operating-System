
#!/bin/bash
#home/fahmid/Desktop/Offline_SS/sample-io/working_dir/

#!/bin/bash

#!/bin/bash

readarray -t arrCrs <./course.txt
touch "1705087_output.csv"

#echo ${arrCrs[0]}
i=0
student=()

while read line
do 
    #echo $line | cut -d' ' -f1
    student+=($(echo $line | cut -d' ' -f1))
done < ${arrCrs[0]}.txt

#echo "${student[@]}"

[ -e "1705087_output.csv" ] && rm "1705087_output.csv"
touch "1705087_output.csv"

varStr="Student no,"
for text in ${arrCrs[@]}; do
    #echo $text" "
    varStr+=$text","
done
varStr+="Total Mark,Avg Mark,Grade"
echo $varStr>> 1705087_output.csv

totalCrs=${#arrCrs[@]}

for std in ${student[@]}; do
    varStr="$std,"
    totalNumber=0
    avgmark=0
    for text in ${arrCrs[@]}; do
        i=$(grep -n "$std" "$text.txt"|cut -d' ' -f2)
        varStr+=$i","
        totalNumber=$((totalNumber+i))
    done
    avgmark=$((totalNumber/totalCrs))
    varStr+=$avgmark
    varStr+=","
    varStr+=$totalNumber
    varStr+=","

    if((avgmark>=80))
        then
            varStr+="A"
    elif((avgmark>=60))
        then
            varStr+="B"
    elif((avgmark>=40))
        then
            varStr+="C"
    else
        varStr+="D"
    fi

    echo $varStr>> 1705087_output.csv
done

s=($(sort <<<"${s[*]}"))

place="Dhaka"

IFS=$'\n'
readarray -t arrFrndt <./friends.txt
readarray -t arrPlc <./places.txt

[ -e "1705087_output.csv" ] && rm "1705087_output.csv"
[ -e "1705087_output.txt" ] && rm "1705087_output.txt"
touch "1705087_output.csv"
touch "1705087_output.txt"

c=9999

for host in ${arrPlc[@]}; do
  i=$(grep -o -i $host visited.csv | wc -l)
  echo $host " " $i>> 1705087_output.csv
  echo $host " " $i>> 1705087_output.txt
  if(($i<$c))
    then
        c=$i
        place=$host
  fi
done

echo "The least visited place $place ">> 1705087_output.txt
echo "The least visited place $place ">> 1705087_output.csv

grep -n "mp" "input.txt"
num_of_lines=$(cat $file | wc -l)

while read line
do
   echo "Record is : $line"
done < visited.csv

while IFS=, read -r field1 field2
do
    echo "$field1 and $field2"
done < visited.csv

cd test
fileName="$1"

IFS=$'\n'
for line in `cat $fileName`; do
    echo "Searching for $line ..."
    # item="test2.txt"
    for item in `find . -type f -not -name "$fileName" | sort`; do
        
        lines=`grep -n "$line" "$item"`

        if [ -n "$lines" ]; then
            echo `echo "$item" | cut -d "/" -f 2`
            lineNos=`echo $lines | cut -d ":" -f 1`
            for n in "$lineNos"; do
                echo "Copy Found in line $n";
            done            
        fi
        
    done
done

VAR="find ./working_dir \("
failed=true

for i in "${arrNotExt[@]}";
do  
  if $failed
  then 
    VAR+=" ! -name \"*.\"${i}"
    failed=false
  else 
    VAR+=" -a ! -name \"*\".${i}"
  fi
done

VAR+=" \) -type f| sort -u"
#echo ${VAR}

#declare -p wantedExt

#wantedExt=($(echo ${allExt[@]} ${arrNotExt[@]} | tr ' ' '\n' | sort | uniq -u))
#echo ""

#find ./working_dir/ \( ${VAR} \) -type f

#find ./working_dir/ \( $VAR \) -type f

#find ./working_dir \( ! -name "*".jpg -a ! -name "*".mp3 -a ! -name "*".mp4 -a ! -name "*".png \) -type f

#find ./working_dir/ \( ! -name "*".jpg -a ! -name "*".mp3  -a ! -name "*".mp4  -a ! -name "*".png \) -type f

#find ./working_dir/ \( ! -name "*".png -a ! -name "*".mp3 \) -type f 

#find ./ -name '.*\.(sh|pdf)' -exec cp {} ./$DIR_FOR_OUTPUT \;

#find ./ -name "*".txt -exec cp {} ./$DIR_FOR_OUTPUT \;

#filename=$(basename -- "$fullfile")
#extension="${filename##*.}"
#filename="${filename%.*}"
